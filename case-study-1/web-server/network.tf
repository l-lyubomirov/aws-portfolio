resource "aws_vpc" "vpc-cl" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "vpc-case-lyubo"
  }
}

resource "aws_internet_gateway" "igw-cl" {
  vpc_id = aws_vpc.vpc-cl.id
  tags = {
    Name = "igw-case-lyubo"
  }
}

resource "aws_eip" "ngw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw-cl" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = aws_subnet.pu-subnet-cl.id
  tags = {
    Name = "NAT gateway"
  }
  depends_on = [aws_internet_gateway.igw-cl]
}

resource "aws_subnet" "pu-subnet-cl" {
  vpc_id                  = aws_vpc.vpc-cl.id
  cidr_block              = var.public-subnet-cidr
  availability_zone       = "eu-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-case-lyubo"
  }
}

resource "aws_route_table" "pu-rt-cl" {
  vpc_id = aws_vpc.vpc-cl.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-cl.id
  }
  tags = {
    Name = "public-routetable-case-lyubo"
  }
}

resource "aws_route_table_association" "pu-subnet-route-table-association" {
  subnet_id      = aws_subnet.pu-subnet-cl.id
  route_table_id = aws_route_table.pu-rt-cl.id
}

resource "aws_subnet" "pu-subnet-cl2" {
  vpc_id                  = aws_vpc.vpc-cl.id
  cidr_block              = "10.0.64.0/21"
  availability_zone       = "eu-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-case-lyubo2"
  }
}

resource "aws_route_table" "pu-rt-cl2" {
  vpc_id = aws_vpc.vpc-cl.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-cl.id
  }
  tags = {
    Name = "public-routetable-case-lyubo2"
  }
}

resource "aws_route_table_association" "pu-subnet-route-table-association2" {
  subnet_id      = aws_subnet.pu-subnet-cl2.id
  route_table_id = aws_route_table.pu-rt-cl2.id
}

resource "aws_subnet" "pr-subnet-cl" {
  vpc_id                  = aws_vpc.vpc-cl.id
  cidr_block              = var.private-subnet-cidr
  availability_zone       = "eu-south-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-case-lyubo"
  }
}

resource "aws_route_table" "pr-rt-cl" {
  vpc_id = aws_vpc.vpc-cl.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-cl.id
  }
  tags = {
    Name = "private-routetable-case-lyubo"
  }
}

resource "aws_route_table_association" "pr-subnet-route-table-association" {
  subnet_id      = aws_subnet.pr-subnet-cl.id
  route_table_id = aws_route_table.pr-rt-cl.id
}