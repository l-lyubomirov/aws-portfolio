resource "aws_instance" "bastion-host" {
  ami                    = "ami-03a68febd9b9a5403"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.pu-subnet-cl.id
  vpc_security_group_ids = [aws_security_group.securitygroup-cl.id]
  iam_instance_profile   = aws_iam_instance_profile.profile-ec2-iam-bastion.name
  key_name               = "ec2-ssh-key"
  tags = {
    Name = "bastion-host"
  }
}
