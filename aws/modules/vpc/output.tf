output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "vpc_security_group_id" {
  value = aws_security_group.my_security_group.id
  description = "The ID of the VPC security group"
}


