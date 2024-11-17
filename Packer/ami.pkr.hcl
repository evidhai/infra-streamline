variable "aws_region" {
    default = "eu-west-1"
}

variable "instance_type" {
    default = "t2.micro"
}

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


source "amazon-ebs" "ubuntu" {
    region           = var.aws_region
    instance_type    = var.instance_type
    source_ami_filter {
        filters = {
            virtualization-type = "hvm"
            name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
            root-device-type    = "ebs"
        }
        owners      = ["099720109477"]
        most_recent = true
    }
    ssh_username     = "ubuntu"
    ami_name         = "vasan-packer-demo-{{timestamp}}"
}

build {
    sources = ["source.amazon-ebs.ubuntu"]

    provisioner "shell" {
        inline = [
            "sudo sed -i 's|http://archive.ubuntu.com/ubuntu|http://us.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list",
            "sudo apt-get update -y",
            "sudo apt-get install -y apache2 --fix-missing apache2",
            "echo 'Hello, Apache is running!' | sudo tee /var/www/html/index.html"

        ]
    }
}