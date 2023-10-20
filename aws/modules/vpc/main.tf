provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
 
  tags = {
    Name        = "my-vpc"
    Environment = var.environment
  }
  
}

resource "aws_security_group" "my_sg" {
  name        = "my-sg"
  description = "My Security Group"
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
    Name        = "my-sg"
    Environment = var.environment
  }
}
