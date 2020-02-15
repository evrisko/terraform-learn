#Using different region, alias

provider "aws" {
  region = "eu-central-1"
  /*
  assume_role {
    role_arn = "arn:aws:iam:123123123123:role/RemoteAdmin"
    session_name = "terraform-session"
  }
*/
}

provider "aws" {
  region = "eu-west-1"
  alias  = "Ireland"
}
provider "aws" {
  region = "eu-west-2"
  alias  = "London" // for pointer
}

data "aws_ami" "ire_latest_amazon" {
  provider    = aws.Ireland
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
data "aws_ami" "london_latest_amazon" {
  provider    = aws.London
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "fra_server" {
  instance_type = "t2.micro"
  ami           = "ami-0df0e7600ad0913a9"
  tags = {
    Name = "Frankfurt server"
  }
}
resource "aws_instance" "ire_server" {
  provider      = aws.Ireland // pointer to region
  instance_type = "t2.micro"
  ami           = data.aws_ami.ire_latest_amazon.id
  tags = {
    Name = "Ireland server"
  }
}
resource "aws_instance" "london_server" {
  provider      = aws.London
  instance_type = "t2.micro"
  ami           = data.aws_ami.london_latest_amazon.id
  tags = {
    Name = "London server"
  }
}
