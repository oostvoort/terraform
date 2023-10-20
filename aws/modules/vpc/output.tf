output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "vpc_security_group_id" {
  value = aws_security_group.my_security_group.id
  description = "The ID of the VPC security group"
}

output "public_subnet_ids" {
  value = module.my_vpc.public_subnets.*.id
  description = "The IDs of the created subnets"
}

output "private_subnet_ids" {
  value = module.my_vpc.private_subnets.*.id
  description = "The IDs of the created subnets"
}

output "vpc_cidr_block" {
  value = module.my_vpc.cidr
}
