variable "vpc_cidr" {
  default = "10.10.0.0/16"
}
variable "env" {
  default = "dev"
}
variable "public_subnet_cidrs" {
  default = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]
}
