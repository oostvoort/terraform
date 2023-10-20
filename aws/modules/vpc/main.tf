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
    flatten([for az in data.aws_availability_zones.available.names : list(az, length(var.subnet_cidrs))]), 
    count.index
  )

  tags = {
    Name = "${var.projectname}-${var.environment}-subnet-${count.index}"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "${var.projectname}-${var.environment}-sg"
  vpc_id      = aws_vpc.my_vpc.id
  
  tags = {
  Name = "${var.projectname}-${var.environment}-sg"
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
}