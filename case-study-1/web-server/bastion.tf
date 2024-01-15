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

resource "aws_iam_instance_profile" "profile-ec2-iam-bastion" {
  name = "ec2-profile-bastion"
  role = aws_iam_role.iam-role-ssm-bastion.name
}

resource "aws_iam_role" "iam-role-ssm-bastion" {
  name        = "ssm-iam-role-bastion"
  description = "The role for the developer resources EC2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach-bastion" {
  role       = aws_iam_role.iam-role-ssm-bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}