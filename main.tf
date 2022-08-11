terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}

# Find latest ubuntu ami
data "aws_ami" "latest_ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "TerraformExampleAppServerInstance"
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.latest_ubuntu_ami.id
  instance_type = "t2.micro"
  tags = {
    Name = var.instance_name
  }
}
