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

resource "aws_security_group" "security-group1" {
  vpc_id = aws_vpc.vpc.id
  name   = "security-group1-${var.project-name}"

  dynamic "ingress" {
    for_each = var.security-group1-ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.security-group1-egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "security-group1-${var.project-name}"
  }
}

resource "aws_security_group" "webserver-securitygroup" {
  vpc_id = aws_vpc.vpc.id
  name   = "webserver-security-group-${var.project-name}"

  dynamic "ingress" {
    for_each = var.security-group-webserver-ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.security-group1-egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "ws-security-group-${var.project-name}"
  }
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id

  dynamic "egress" {
    for_each = var.nacl-egress
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }
  dynamic "ingress" {
    for_each = var.nacl-ingress
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }
  tags = {
    Name = "nacl-${var.project-name}"
  }
}

resource "aws_flow_log" "flow-logs" {
  iam_role_arn    = aws_iam_role.role-flowlogs.arn
  log_destination = aws_cloudwatch_log_group.cw-log-gr.arn
  traffic_type    = var.flow_logs_traffic_type
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "cw-log-gr" {
  name = "Clowdwatch-log-gr-${var.project-name}"
}

resource "aws_iam_role" "role-flowlogs" {
  name               = "Flowlogs-role-${var.project-name}"
  assume_role_policy = var.flowlog-policy-role
}

resource "aws_iam_role_policy" "policy-flowlogs" {
  name   = "Policy-flowlogs-${var.project-name}"
  role   = aws_iam_role.role-flowlogs.id
  policy = var.flow-log-polices
}
