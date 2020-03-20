provider "aws" {
  region = "eu-central-1"
}
terraform {
  backend "s3" {
    bucket = "s3-terraform-ansible-euvrisko"
    key    = "ansible/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}
data "terraform_remote_state" "security" {
  backend = "s3"
  config  = {
    bucket = "s3-terraform-ansible-euvrisko"
    key    = "ansible/security/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "aws_route53_zone" "selected" {
  name = var.hosted_zone
}

data "aws_ami" "latest_amazon" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
resource "aws_instance" "ansible_client_amazon" {
  count                  = 2
  ami                    = data.aws_ami.latest_amazon.id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.security_group_id]
  instance_type          = var.instance_type
  key_name               = "aws-key"
  tags = {
    Name    = "Ansible_Client ${count.index + 1}"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_instance" "ansible_client_ubuntu" {
  count                  = 1
  ami                    = data.aws_ami.latest_ubuntu.id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.security_group_id]
  instance_type          = var.instance_type
  key_name               = "aws-key"
  tags = {
    Name    = "Ansible_Client ${count.index + 1}"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_instance" "ansible_master" {
  ami                    = data.aws_ami.latest_amazon.id
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.security_group_id]
  instance_type          = var.instance_type
  key_name               = "aws-key"
  tags = {
    Name    = "Ansible_Master"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.my_static_global.public_ip]
}
resource "aws_eip" "my_static_global" {
  instance = aws_instance.ansible_master.id
  tags = {
    Name    = "Global IP Ansible Master"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
}

