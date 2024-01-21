variable "region" {
  description = "The region for the project"
  type        = string
}

variable "project-name" {
  description = "The name of the project."
  type        = string
}

variable "vpc-cidr" {
  description = "VPC cidr block"
  type        = string
}

variable "public-subnet-cidrs" {
  description = "Public Subnet CIDR values"
  type        = list(string)
}

variable "public-subnet-azs" {
  description = "Public Subnet CIDR values"
  type        = list(string)
}

variable "private-subnet-cidr" {
  description = "Private subnet cidr block"
  type        = string
}

variable "default-route-cidr" {
  description = "The default route for the rooting tabel"
  type        = string
}

variable "security-group1-ingress" {
  description = "The ingress rules for the first security group"
  type = object({
    ingress_ssh = object({
      description = string
      from_port   = string
      to_port     = string
      protocol    = string
      cidr_blocks = list(string)
    })
  })
}

variable "security-group1-egress" {
  description = "The egress rules for the first security group"
      type = object({
    egress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
  })
}

variable "security-group-webserver-ingress" {
  description = "The ingress rules for the web server security group"
      type = object({
    Ingress_SSH = object({
      description = string
      from_port   = string
      to_port     = string
      protocol    = string
      cidr_blocks = list(string)
    })
  })
}

variable "nacl-egress" {
  description = "The egress rules for the nacl"
  type = object({
    egress-all = object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    })
  })
}

variable "nacl-ingress" {
  description = "The ingress rules for the nacl"
  type = object({
    ingress-all = object({
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    })
  })
}

variable "flow_logs_traffic_type" {
  description = "The type of traffic collected by the flow logs"
  type        = string
}

variable "subnet-public-map" {
  description = "The map of the public subnets"
  type        = bool
}

variable "flowlog-policy-role" {
  description = "This variable is used to refer the json file for the flow logs role"
  type = string
}

variable "flow-log-polices" {
  description = "This variable is used to refer the json file for the policies for the flow logs role"
  type = string
}