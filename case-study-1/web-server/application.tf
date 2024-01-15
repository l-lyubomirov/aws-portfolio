resource "aws_lb" "alb" {
  name               = "application-lb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ws-securitygroup-cl.id]
  subnets = [aws_subnet.pu-subnet-cl.id,
  aws_subnet.pu-subnet-cl2.id]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  health_check {
    enabled             = true
    interval            = 60
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5 #6
    healthy_threshold   = 5
    unhealthy_threshold = 10 #3
    matcher             = "403,200"
    port                = "traffic-port"
  }

  name        = "alb-targetgtoup"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc-cl.id
}

resource "aws_launch_template" "launch-template" {
  name_prefix            = "foobar"
  image_id               = "ami-03a68febd9b9a5403"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ws-securitygroup-cl.id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.profile-ec2-iam.arn
  }
  key_name  = "ec2-ssh-key"
  user_data = filebase64("scripts/apache-userdata.sh")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server"
    }
  }
  depends_on = [
    aws_nat_gateway.ngw-cl,
    aws_lb.alb
  ]
}

resource "aws_autoscaling_group" "autoscaling-group" {
  name                      = "autoscaling-group-cl"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.pr-subnet-cl.id]
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.alb-target-group.arn]
  launch_template {
    id = aws_launch_template.launch-template.id
  }
}

resource "aws_iam_instance_profile" "profile-ec2-iam" {
  name = "ec2-profile"
  role = aws_iam_role.iam-role-ssm.name
}

resource "aws_iam_role" "iam-role-ssm" {
  name        = "ssm-iam-role"
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

resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach" {
  role       = aws_iam_role.iam-role-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "s3-policy-cl" {
  name        = "s3-getobject-policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [

        "arn:aws:s3:::terraform-state-lyubo/*"]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3getobject-role-policy-attach" {
  role       = aws_iam_role.iam-role-ssm.name
  policy_arn = aws_iam_policy.s3-policy-cl.arn
}