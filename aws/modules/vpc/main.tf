provider "aws" {
  region = var.aws_region
}
# VPC
module "my_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "${var.projectname}-${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${var.projectname}-${var.environment}-default" }
  enable_dns_hostnames = true
  enable_dns_support   = true

}
# Subnet
resource "aws_subnet" "my_subnet" {
  count                  = length(var.subnet_cidrs)
  vpc_id                 = aws_vpc.my_vpc.id
  cidr_block             = var.subnet_cidrs[count.index]
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.projectname}-${var.environment}-subnet-${count.index + 1}"
    Environment = var.environment
  }
}
# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "${var.projectname}-${var.environment}-sg"
  description = "${var.projectname}-${var.environment}-sg"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = [
      { from_port = 3000, to_port = 3000, protocol = "tcp" },
      { from_port = 8080, to_port = 8080, protocol = "tcp" },
      { from_port = 5050, to_port = 5050, protocol = "tcp" }
    ]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name        = "${var.projectname}-${var.environment}-sg"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.projectname}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Attach Internet Gateway to VPC
resource "aws_vpc_ipv4_cidr_block_association" "my_vpc_cidr" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = aws_vpc.my_vpc.cidr_block
}

# Route Table pointing to the Internet Gateway
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name        = "${var.projectname}-${var.environment}-route-table"
    Environment = var.environment
  }
}

# Associate Route Table with the Subnet
# resource "aws_route_table_association" "my_route_table_assoc" {
#   count          = length(aws_subnet.my_subnet)
#   subnet_id      = element(aws_subnet.my_subnet.*.id, count.index)
#   route_table_id = aws_route_table.my_route_table.id
# }

resource "aws_route_table_association" "my_route_table_assoc" {
  count = length(aws_subnet.my_subnet.*.id)

  subnet_id      = aws_subnet.my_subnet[count.index].id
  route_table_id = aws_route_table.my_route_table.id
}