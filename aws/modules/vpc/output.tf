output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_security_group_id" {
  value = aws_security_group.my_security_group.id
  description = "The ID of the VPC security group"
}

output "subnet_ids" {
  value = aws_subnet.my_subnet.*.id
  description = "The IDs of the created subnets"
}