terraform {
  backend "s3" {
    bucket = "${var.projectname}-${var.environment}-statefile"
    key    = "/"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.projectname}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  count = length(var.subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = element(
    flatten([for az in data.aws_availability_zones.available.names : [for _ in var.subnet_cidrs : az]]),
    count.index
  )

  tags = {
    Name = "${var.projectname}-${var.environment}-subnet-${count.index}"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "${var.projectname}-${var.environment}-sg"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
  Name = "${var.projectname}-${var.environment}-sg"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.projectname}-${var.environment}-igw"
  }  
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.projectname}-${var.environment}-route-table"
  }
}

resource "aws_route_table_association" "my_route_table_assoc" {
  count          = length(aws_subnet.my_subnet)
  subnet_id      = element(aws_subnet.my_subnet.*.id, count.index)
  route_table_id = aws_route_table.my_route_table.id

}

locals {
  bucket_name = try(data.aws_s3_bucket.existing[0].id, aws_s3_bucket.new[0].id)

}

resource "aws_s3_bucket" "new" {
  count  = 0
  bucket = "${var.projectname}-${var.environment}-statefile"
}