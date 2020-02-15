provider "aws" {
  region = "eu-central-1"
}

# push tfstate to remote location in S3 backet
terraform {
  backend "s3" {
    bucket = "s3-terraform-remote-state-euvrisko"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

# pull data from s3 bucket, before need to initialize output id that you need to use
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "s3-terraform-remote-state-euvrisko"
    key    = "dev/network/terraform.tfstate"
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

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon.id
  instance_type          = "t2.micro"
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.mywebserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id[0]
  user_data              = <<EOF
#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PrivateIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h3>Hostname: $(hostname -f)</h3>" > /var/www/html/index.html
echo "Availability-zone: $EC2_AVAIL_ZONE" >> /var/www/html/index.html
echo "<br>PrivateIP: $PrivateIP" >> /var/www/html/index.html
echo "----------FINISH-------------------"
EOF
  tags = {
    Name = "WebServer"
  }
}


resource "aws_security_group" "mywebserver" {
  name        = "WebServer Security Group"
  description = "Allow HTTP HTTPS"
  # vpc_id come from output Layer1
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.209.228.99/32"]
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

output "network_details" {
  value = data.terraform_remote_state.network
}
output "sg_mywebserver_id" {
  value = aws_security_group.mywebserver.id
}
output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
