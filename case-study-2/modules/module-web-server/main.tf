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

resource "aws_lb" "alb" {
  name               = "application-lb-${var.project-name}"
  internal           = var.alb-config.internal
  ip_address_type    = var.alb-config.ip_adress_type
  load_balancer_type = var.alb-config.load_balancer_type
  security_groups    = [var.webserver-securitygroup-id]
  subnets = [var.public-subnet1-id,
  var.public-subnet2-id]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb-listener-config.port
  protocol          = var.alb-listener-config.protocol


  default_action {
    type             = var.alb-listener-config.default_action_type
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  dynamic "health_check" {
    for_each = var.health-check-alb
    content {
      enabled             = health_check.value.enabled
      interval            = health_check.value.interval
      path                = health_check.value.path
      protocol            = health_check.value.protocol
      timeout             = health_check.value.timeout
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
      matcher             = health_check.value.matcher
      port                = health_check.value.port
    }
  }

  name        = "alb-targetgtoup-${var.project-name}"
  port        = var.alb-tg-config.port
  protocol    = var.alb-tg-config.protocol
  target_type = var.alb-tg-config.target_type
  vpc_id      = var.vpc-id
}

resource "aws_launch_template" "launch-template" {
  image_id               = var.ami-webserver
  instance_type          = var.webserver-instance-type
  vpc_security_group_ids = [var.webserver-securitygroup-id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.profile-ec2-iam.arn
  }
  key_name  = var.ec2-bastion-config.key_name
  user_data = var.user-data
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server-${var.project-name}"
    }
  }
  depends_on = [
    var.ngw-id,
    aws_lb.alb
  ]
}

resource "aws_autoscaling_group" "autoscaling-group" {
  name                      = "autoscaling-group-${var.project-name}"
  min_size                  = var.asg-config.min_size
  max_size                  = var.asg-config.max_size
  desired_capacity          = var.asg-config.desired_capacity
  health_check_grace_period = var.asg-config.health_check_grace_period
  vpc_zone_identifier       = [var.private-subnet-id]
  target_group_arns         = [aws_lb_target_group.alb-target-group.arn]
  launch_template {
    id = aws_launch_template.launch-template.id
  }
}

resource "aws_iam_instance_profile" "profile-ec2-iam" {
  name = "ec2-profile-${var.project-name}"
  role = aws_iam_role.iam-role-ssm.name
}

resource "aws_iam_role" "iam-role-ssm" {
  name               = "ssm-iam-role-${var.project-name}"
  description        = "The role for the developer resources EC2"
  assume_role_policy = var.assume-policy-role
}

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach" {
  role       = aws_iam_role.iam-role-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "s3-policy" {
  name        = "s3-getobject-policy-${var.project-name}"
  description = "Provides permission to access S3"
  policy      = var.s3-policy
}

resource "aws_iam_role_policy_attachment" "s3getobject-role-policy-attach" {
  role       = aws_iam_role.iam-role-ssm.name
  policy_arn = aws_iam_policy.s3-policy.arn
}