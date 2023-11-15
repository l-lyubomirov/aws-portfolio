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