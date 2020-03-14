provider "aws" {
  region = "eu-central-1"
}
terraform {
  backend "s3" {
    bucket = "s3-terraform-ansible-euvrisko"
    key    = "ansible/terraform.tfstate"
    region = "eu-central-1"
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
  vpc_security_group_ids = [aws_security_group.ansible_client.id]
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
  vpc_security_group_ids = [aws_security_group.ansible_client.id]
  instance_type          = var.instance_type
  key_name               = "aws-key"
  tags = {
    Name    = "Ansible_Client ${count.index + 1}"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
}
/*resource "aws_instance" "ansible_master" {
  ami                    = data.aws_ami.latest_amazon.id
  vpc_security_group_ids = [aws_security_group.my_ansible_client.id]
  instance_type          = var.instance_type
  key_name               = "aws-key"
  tags = {
    Name    = "Ansible_Master"
    Owner   = "Aleh Baslaviak"
    Project = var.project
    Env     = var.environment
  }
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
*/
resource "aws_security_group" "ansible_client" {
  name        = "Ansible_client Security Group"
  description = "Allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Access SSH from VPC"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["82.209.228.99/32"]
    description = "Access HTTP from home"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ICMP from any"
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
    Project = var.project
  }
}
