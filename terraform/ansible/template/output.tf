output "ansible_master_eip" {
  value = aws_eip.my_static_global.public_ip
}
output "data_aws_route53_zone" {
  value = data.aws_route53_zone.selected.zone_id
}
