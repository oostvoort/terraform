output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet.*.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_gw.id
}
