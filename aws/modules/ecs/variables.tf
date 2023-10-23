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

variable "registry" {
  description = "The name of the registry"
  type        = string
}

variable "cpu" {
  description = "The amount of cpu assigned to fargate container"
  type        = number
}

variable "memory" {
  description = "The amount of memory assigned to fargate container"
  type        = number
}
                    

variable "desired_count" {
  default = 1
}

variable "vpc_subnets" {
  description = "List of VPC Subnet IDs"
  type        = list(string)
  default     = []
}

variable "vpc_security_group" {
  description = "VPC Security Group ID"
  type        = string
}

variable containerport {
  description = "Docker container port"
  type        = number

}

variable "port_mappings" {
  description = "List of port mappings"
  type        = list(object({ containerPort = number, hostPort = number }))
}
