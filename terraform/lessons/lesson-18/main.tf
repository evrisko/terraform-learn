# Lesson about count, for if
# from adv-it

provider "aws" {
  region = "eu-central-1"
}

variable "users" {
  description = "List of IAM Users to create"
  default     = ["nick", "tom", "ben", "max", "serg", "kris", "andry"]
}

resource "aws_iam_user" "user1" {
  name = "alex"
}

resource "aws_iam_user" "users" {
  count = length(var.users)
  name  = element(var.users, count.index)
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0df0e7600ad0913a9"
  instance_type = "t2.micro"
  tags = {
    Name = "server number ${count.index + 1}" //useful
  }
}

output "created_iam_users" {
  value = aws_iam_user.users
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}
# for user in - "user" can be anything (x example)
output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name}, ARN: ${user.arn}"
  ]
}

#map
output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id // ""AIDAZ7QK5WWKU5FU7BUKQ : nick
  }
}
// print list of users with 4 char
output "custom_if_lenght" {
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 4
  ]
}

#pring nice MAP of instance ID Public IP
output "server_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
