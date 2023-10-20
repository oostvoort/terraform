variable "sg_name" {
  description = "The name for the security group"
  type        = string
}

variable "sg_description" {
  description = "The description for the security group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID to create the security group in"
  type        = string
}

variable "from_port" {
  description = "The start port for the ingress rule"
  type        = number
}

variable "to_port" {
  description = "The end port for the ingress rule"
  type        = number
}

variable "protocol" {
  description = "The protocol for the ingress rule"
  type        = string
  default     = "tcp"
}

variable "cidr_blocks" {
  description = "List of CIDR blocks to allow in the security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "ingress_ports" {
  description = "List of ports to open for ingress"
  type        = list(number)
  default     = [3000, 8080, 5050]
}


variable "tags" {
  description = "Tags to attach to the security group"
  type        = map(string)
  default     = {}
}