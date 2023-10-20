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

variable "registry" {
  description = "The name of the registry"
  type        = string
  default     = ""
}

variable "cpu" {
  description = "The amount of cpu assigned to fargate container"
  type        = number
  default     = "256"
}

variable "memory" {
  description = "The amount of memory assigned to fargate container"
  type        = number
  default     = "512"
}
                    

variable "desired_count" {
  default = 1
}
variable "vpc_subnets" {
  type = list(string)
}

variable "vpc_security_group" {
  type = string
}