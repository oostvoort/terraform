provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
 
  tags = {
    Name        = "${var.projectname}-${var.environment}"
    Environment = var.environment
  }
  
}

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

resource "aws_security_group" "my_sg" {
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
