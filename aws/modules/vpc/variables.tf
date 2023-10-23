variable "environment" {
  description = "Environment label, e.g., dev, staging, main"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
}

variable "projectname" {
  description = "The name of the project"
  type        = string
}

variable "cidr_block" {
  description = "IP range for the VPC cidr block"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDRs for subnets"
  type        = string
}

variable "ingress_ports" {
  description = "List of ports to allow in the security group"
  type        = list(number)
}

variable "use_existing_bucket" {
  description = "Use existing S3 bucket"
  type        = bool
}
