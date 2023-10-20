variable "environment" {
  description = "Environment label, e.g., dev, staging, main"
  type        = string
  default = "main"
}

variable "aws_region" {
  description = "AWS region to deploy resources in."
  default     = "us-east-1"
}