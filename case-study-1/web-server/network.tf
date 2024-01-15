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

resource "aws_security_group" "securitygroup-cl" {
  vpc_id = aws_vpc.vpc-cl.id
  name   = "security-group-case-lyubo"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["178.254.247.173/32"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-case-lyubo"
  }
}

resource "aws_security_group" "ws-securitygroup-cl" {
  vpc_id = aws_vpc.vpc-cl.id
  name   = "ws-security-group-case-lyubo"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.securitygroup-cl.id]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ws-security-group-case-lyubo"
  }
}

resource "aws_network_acl" "nacl-cl" {
  vpc_id = aws_vpc.vpc-cl.id

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_flow_log" "flow-logs" {
  iam_role_arn    = aws_iam_role.role-flowlogs.arn
  log_destination = aws_cloudwatch_log_group.cw-log-gr.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc-cl.id
}

resource "aws_cloudwatch_log_group" "cw-log-gr" {
  name = "Clowdwatch-log-group"
}

resource "aws_iam_role" "role-flowlogs" {
  name = "Flowlogs-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "vpc-flow-logs.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "policy-flowlogs" {
  name = "Policy-flowlogs"
  role = aws_iam_role.role-flowlogs.id

  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}