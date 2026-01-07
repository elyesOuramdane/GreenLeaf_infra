variable "environment" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private app subnet IDs where instances will run"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "min_size" {
  type        = number
  description = "ASG minimum instances"
}

variable "desired_capacity" {
  type        = number
  description = "ASG desired instances"
}

variable "max_size" {
  type        = number
  description = "ASG maximum instances"
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALB Target Group ARN (optional)"
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instances"
  type        = list(string)
  default     = []
}
