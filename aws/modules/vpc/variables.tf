variable "orgname" {
  description = "Name of the organzation that owns this resource"
  default     = "oostvoort"
}

variable "environment" {
  description = "Environment label, e.g., dev, staging, main"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "projectname" {
  description = "The name of the project"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "IP range for the VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDRs for subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ingress_ports" {
  description = "List of ports to allow in the security group"
  type        = list(number)
  default     = [3000, 8080, 5050]
}

variable "create_new_bucket" {
  description = "Flag to create a new S3 bucket."
  default     = true
}