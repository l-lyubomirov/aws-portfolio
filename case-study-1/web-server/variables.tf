variable "vpc-cidr" {
  default     = "10.0.0.0/16"
  description = "VPC cidr block"
  type        = string
}

variable "public-subnet-cidr" {
  default     = "10.0.32.0/20"
  description = "Public subnet cidr block"
  type        = string
}
variable "private-subnet-cidr" {
  default     = "10.0.0.0/19"
  description = "Private subnet cidr block"
  type        = string
}