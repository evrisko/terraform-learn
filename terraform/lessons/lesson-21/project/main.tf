provider "aws" {
  region = "eu-west-3"
}
/*
module "vpc-default" {
  source = "../modules/aws_network"
}
*/

module "vpc-prod" {
  source               = "../modules/aws_network"
  env                  = "production"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.12.0/24"]
}

module "vpc-dev" {
  source               = "../modules/aws_network"
  env                  = "development"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = []
}

output "prod_public_subnet_ids" {
  value = module.vpc-prod.public_subnet_id
}
output "prod_private_subnet_ids" {
  value = module.vpc-prod.private_subnet_id
}
output "dev_public_subnet_ids" {
  value = module.vpc-dev.public_subnet_id
}
output "dev_private_subnet_ids" {
  value = module.vpc-dev.private_subnet_id
}
