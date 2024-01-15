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