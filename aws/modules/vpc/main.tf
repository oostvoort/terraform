resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "my_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  count = length(var.subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = element(
    flatten([for az in var.availability_zones : list(az, length(var.subnet_cidrs))]), count.index)
  tags = {
    Name = "my_subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  count = length(aws_subnet.my_subnet)
  subnet_id      = aws_subnet.my_subnet[count.index].id
  route_table_id = aws_route_table.my_route_table.id
}
