resource "aws_instance" "server" {
  # ami                    = "ami-0fcc0bef51bad3cb2"
  ami                    = "ami-076039fe8a805d252"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-02cb98388e7165696"]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, Apache is running!" > /var/www/html/index.html
              EOF
}

output "instance_public_ip" {
  value = aws_instance.server.public_ip
}

provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

