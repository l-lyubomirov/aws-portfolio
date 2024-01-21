#!/bin/bash
  yum update -y
  yum install httpd -y
  systemctl enable httpd
  systemctl start httpd
  cd /var/www/html
  sudo aws s3 cp s3://web-server-html-lyubo/index.html index.html --region eu-south-1