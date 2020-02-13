# Lesson from adv-it
# locals variable

provider "aws" {}

locals {
  full_name_project = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner}-${var.project_name}"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  country = "Belarus"
  city    = "Minsk"
  az_list = join(",", data.aws_availability_zones.available.names)
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name         = "Static IP"
    Owner        = var.owner
    Project      = local.full_name_project
    Project_info = local.project_owner
    city         = local.city
    az-list      = local.az_list
  }
}
