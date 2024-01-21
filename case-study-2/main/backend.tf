terraform {
  backend "s3" {
    bucket         = "terraform-state-lyubo"
    key            = "web-server-2/terraform.state"
    region         = "eu-south-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}