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