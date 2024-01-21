variable "region" {
  default     = "eu-south-1"
}

variable "project-name" {
  default     = "case2-lyubo"
}

variable "vpc-cidr" {
  default     = "10.0.0.0/16"
}

variable "public-subnet-cidrs" {
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "public-subnet-azs" {
  default     = ["eu-south-1a", "eu-south-1b"]
}

variable "private-subnet-cidr" {
  default     = "10.0.5.0/24"
}

variable "default-route-cidr" {
  default     = "0.0.0.0/0"
}

variable "security-group1-ingress" {
  default = {
    ingress_ssh = {
      description = "SSH"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["178.254.247.173/32"]
    }
  }
}

variable "security-group1-egress" {
  default = {
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "security-group-webserver-ingress" {
  default = {
    Ingress_SSH = {
      description = "HTTP"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    "Ingress HTTP" = {
      description = "SSH"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["178.254.247.173/32"]
    }
  }
}

variable "nacl-egress" {
  default = {
    egress-all = {
      protocol   = "all"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  }
}

variable "nacl-ingress" {
  default = {
    ingress-all = {
      protocol   = "all"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  }
}

variable "flow_logs_traffic_type" {
  default     = "ALL"
}

variable "subnet-public-map" {
  default     = true
}

variable "ec2-bastion-config" {
  default = {
    ami           = "ami-03a68febd9b9a5403"
    instance_type = "t3.micro"
    key_name      = "ec2-ssh-key"
  }
}

variable "health-check-alb" {
  default = {
    health-check = {
      enabled             = true
      interval            = 60
      path                = "/"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 5
      unhealthy_threshold = 10
      matcher             = "403,200"
      port                = "traffic-port"
    }
  }
}

variable "ami-webserver" {
  default     = "ami-03a68febd9b9a5403"
}

variable "webserver-instance-type" {
  default     = "t3.micro"
}

variable "asg-config" {
  default = {
    min_size                  = 1
    max_size                  = 2
    desired_capacity          = 1
    health_check_grace_period = 300
  }
}

variable "alb-config" {
  default = {
    internal           = false
    ip_adress_type     = "ipv4"
    load_balancer_type = "application"
  }
}

variable "alb-listener-config" {
  default = {
    port                = 80
    protocol            = "HTTP"
    default_action_type = "forward"
  }
}

variable "alb-tg-config" {
  default = {
    port        = 80
    protocol    = "HTTP"
    target_type = "instance"
  }
}
