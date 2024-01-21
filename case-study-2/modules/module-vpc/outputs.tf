output "public-subnet1-id" {
  value = aws_subnet.pu-subnet[0].id
}

output "public-subnet2-id" {
  value = aws_subnet.pu-subnet[1].id
}

output "security-group1-id" {
  value = aws_security_group.security-group1.id
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "webserver-securitygroup-id" {
  value = aws_security_group.webserver-securitygroup.id
}

output "private-subnet-id" {
  value = aws_subnet.private-subnet.id
}

output "ngw-id" {
  value = aws_nat_gateway.ngw.id
}