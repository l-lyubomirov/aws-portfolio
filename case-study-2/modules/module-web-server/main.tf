resource "aws_instance" "bastion-host" {
  ami                    = var.ec2-bastion-config.ami
  instance_type          = var.ec2-bastion-config.instance_type
  key_name               = var.ec2-bastion-config.key_name
  subnet_id              = var.public-subnet1-id #pu-subnet-az-a
  iam_instance_profile   = aws_iam_instance_profile.profile-ec2-iam-bastion.name
  vpc_security_group_ids = [var.security-group1-id]

  tags = {
    Name = "bastion-host-${var.project-name}"
  }
}

resource "aws_iam_instance_profile" "profile-ec2-iam-bastion" {
  name = "ec2-profile-bastion-${var.project-name}"
  role = aws_iam_role.iam-role-bastion.name
}

resource "aws_iam_role" "iam-role-bastion" {
  name               = "iam-role-bastion-${var.project-name}"
  description        = "The role for the developer resources EC2"
  assume_role_policy = var.assume-policy-role
}

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach-bastion" {
  role       = aws_iam_role.iam-role-bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}