provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Lyubo"
      Project     = "Case-study2"
    }
  }
}