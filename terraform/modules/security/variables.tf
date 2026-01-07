variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC CIDR"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID of the application instances (ASG)"
  type        = string
}
