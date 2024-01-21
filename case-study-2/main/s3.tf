resource "aws_s3_bucket" "html-bucket" {
  bucket = "web-server-html-lyubo"
  tags = {
    Name        = "Bucket for html setup"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "html-file" {
  bucket = aws_s3_bucket.html-bucket.id
  key    = "index.html"
  source = "${path.module}/html-setup/index.html"
}
