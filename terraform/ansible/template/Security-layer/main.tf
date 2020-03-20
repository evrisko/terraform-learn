provider "aws" {
  region = "eu-central-1"
}
terraform {
  backend "s3" {
    bucket = "s3-terraform-ansible-euvrisko"
    key    = "ansible/security/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_security_group" "ansible_client" {
  name        = "Ansible_client Security Group"
  dynamic "ingress" { 
    for_each = ["172.31.0.0/16", "82.209.228.99/32", "212.98.163.82/32"]
    content {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = ["172.31.0.0/16", "82.209.228.99/32", "212.98.163.82/32"]
    content {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [ingress.value]
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
  }


}

output "security_group_id" {
  value = aws_security_group.ansible_client.id
}
