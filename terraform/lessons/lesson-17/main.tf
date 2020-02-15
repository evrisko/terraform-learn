# Terraform conditions and Lookups
# Lessons from adv-it

provider "aws" {
  region = "eu-central-1"
}

variable "env" {
  default = "dev"
}
variable "prod_owner" {
  default = "Aleh Boslovyak"
}
variable "noprod_owner" {
  default = "Semen Sisko"
}
variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t2.micro"
    "staging" = "t2.nano"
  }
}
variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "8080", "443", "22"]
  }
}

data "aws_ami" "latest_amazon" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "my_webserver1" {
  ami = data.aws_ami.latest_amazon.id
  #  instance_type = var.env == "prod" ? "t2.micro" : "t2.nano"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}
resource "aws_instance" "my_webserver2" {
  count         = var.env == "dev" ? 1 : 0 #list
  ami           = data.aws_ami.latest_amazon.id
  instance_type = "t2.micro"
  tags = {
    Name = "Bastion server for DEV-server"
  }
}
resource "aws_instance" "my_webserver3" {
  ami           = data.aws_ami.latest_amazon.id
  instance_type = lookup(var.ec2_size, var.env)
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}
resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow HTTP HTTPS"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "Security group Web Server AWS"
    Owner   = "Aleh Baslaviak"
    Project = "Learning Terraform"
  }
}
