output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet.*.id
  description = "The IDs of the created subnets"
}