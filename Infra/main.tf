resource "aws_instance" "server" {
  # ami                    = "ami-0fcc0bef51bad3cb2"
  ami                    = "ami-001580acbcd798ddf"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-02cb98388e7165696"]
  user_data              = <<-EOF
              #!/bin/bash
              systemctl start httpd
              systemctl enable httpd
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

