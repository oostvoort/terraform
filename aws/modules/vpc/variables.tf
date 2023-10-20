variable "cidr_block" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type = list(string)
  default = ["us-west-2a", "us-west-2b"]
}
