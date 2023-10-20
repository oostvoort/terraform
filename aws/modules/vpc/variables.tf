variable "environment" {
  description = "Environment label, e.g., dev, staging, main"
  type        = string
  default = ""
}

variable "aws_region" {
  description = "AWS region to deploy resources in."
  default     = ""
}

variable "projectname" {
  description = "The name of the project"
  type        = string
  default     = ""
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}