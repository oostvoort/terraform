output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet[*].id
}

output "security_group_id" {
  value = aws_security_group.my_security_group.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_igw.id
}