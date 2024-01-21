resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "vpc-${var.project-name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-${var.project-name}"
  }
}

resource "aws_eip" "ngw-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = aws_subnet.pu-subnet[0].id
  tags = {
    Name = "ngw-${var.project-name}"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "pu-subnet" {
  count                   = length(var.public-subnet-cidrs)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.public-subnet-azs[count.index]
  map_public_ip_on_launch = var.subnet-public-map
  cidr_block              = var.public-subnet-cidrs[count.index]
  tags = {
    Name = "public-subnet-${var.project-name}-${var.public-subnet-azs[count.index]}"
  }
}

resource "aws_route_table" "public-route-table" {
  count  = length(var.public-subnet-cidrs)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.default-route-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-routetable-${var.project-name}"
  }
}

resource "aws_route_table_association" "pu-subnet-route-table-association" {
  count          = length(var.public-subnet-cidrs)
  subnet_id      = aws_subnet.pu-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table[count.index].id
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private-subnet-cidr
  availability_zone = var.public-subnet-azs[0]
  tags = {
    Name = "private-subnet-${var.project-name}-${var.public-subnet-azs[0]}"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = var.default-route-cidr
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "private-routetable-${var.project-name}"
  }
}

resource "aws_route_table_association" "pr-subnet-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}