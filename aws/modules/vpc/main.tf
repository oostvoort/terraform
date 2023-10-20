provider "aws" {
  region = var.aws_region
}

locals {
  region = var.aws_region
  tags = {
    Organization = var.orgname
    Project      = var.projectname
    Environment  = var.environment
  }
}
# VPC
module "my_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name             = "${var.projectname}-${var.environment}-vpc"
  cidr             = var.cidr
  azs              = ["${local.region}a", "${local.region}b"]
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${var.projectname}-${var.environment}-default" }
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "${var.projectname}-${var.environment}-sg"
  description = "${var.projectname}-${var.environment}-sg"
  vpc_id      = module.my_vpc.vpc_id

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
  vpc_id = module.my_vpc.vpc_id

  tags = {
    Name        = "${var.projectname}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Attach Internet Gateway to VPC
resource "aws_vpc_ipv4_cidr_block_association" "my_vpc_cidr" {
  vpc_id     = module.my_vpc.vpc_id
  cidr_block = module.my_vpc.cidr_block
}

# Route Table pointing to the Internet Gateway
resource "aws_route_table" "my_route_table" {
  vpc_id = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name        = "${var.projectname}-${var.environment}-route-table"
    Environment = var.environment
  }
}
