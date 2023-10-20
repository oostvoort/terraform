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

variable "cidr" {
  description = "IP range for the VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "IP Ranges used for public subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnets" {
  description = "IP Ranges used for private subnets"
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}