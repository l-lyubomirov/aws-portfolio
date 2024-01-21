variable "ec2-bastion-config" {
  description = "The bastion host configuration of ami, isntance type and key name."
  type = object({
    ami           = string
    instance_type = string
    key_name      = string
  })
}

variable "health-check-alb" {
  description = "The rules for the health check of the alb target group"
  type = object({
    health-check = object({
      enabled             = bool
      interval            = number
      path                = string
      protocol            = string
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
      matcher             = string
      port                = string
    })
  })
}

variable "ami-webserver" {
  description = "The AMI of the web server"
  type        = string
}

variable "webserver-instance-type" {
  description = "The instance type of the web server"
  type        = string
}

variable "asg-config" {
  description = "The configuration of the autoscaling group(minimal and maximal size, desired capacity and health check period)"
  type = object({
    min_size                  = number
    max_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
  })
}

variable "project-name" {
  description = "The name of the project."
  type        = string
}

variable "vpc-id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public-subnet1-id" {
  description = "This variable is used to determine public subnet ID from the vpc to the web-server module "
  type        = string
}

variable "public-subnet2-id" {
  description = "This variable is used to determine public subnet ID from the vpc to the web-server module "
  type        = string
}

variable "security-group1-id" {
  description = "This variable is used to determine the ID of a security group from the vpc to the web-server module "
  type        = string
}

variable "webserver-securitygroup-id" {
  description = "This variable is used to determine the ID of a security group from the vpc to the web-server module "
  type        = string
}

variable "ngw-id" {
  description = "This variable is used to determine the ID of the nat-gateway from the vpc to the web-server module "
  type        = string
}

variable "private-subnet-id" {
  description = "This variable is used to determine the ID of a private subnet from the vpc to the web-server module "
  type        = string
}

variable "alb-config" {
  description = "The configuration of the application load balancer"
  type = object({
    internal           = bool
    ip_adress_type     = string
    load_balancer_type = string
  })
}

variable "alb-listener-config" {
  description = "The configuration of the alb listener"
  type = object({
    port                = number
    protocol            = string
    default_action_type = string
  })
}

variable "alb-tg-config" {
  description = "The configuration of the target group for the application load balancer"
  type = object({
    port        = number
    protocol    = string
    target_type = string
  })
}

variable "assume-policy-role" {
  description = "This variable is used to refer the json file for the ec2 role"
  type = string
}

variable "s3-policy" {
  description = "This variable is used to refer the json file for the policies for the S3 role"
  type = string
}

variable "user-data" {
  description = "The user data for the web-server"
  type = string
}