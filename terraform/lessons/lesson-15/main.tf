# Lesson from adv-it
# local-exec

provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform Start: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello world!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Alex"
      NAME2 = "Egor"
      NAME3 = "Max"
    }
  }
}

resource "aws_instance" "myserver" {
  ami           = "ami-07cda0db070313c52"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS EC2 creation!"

  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo Terraform Start: $(date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.myserver]
}
