variable "identifier" {
  description = "Identifier prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Redis"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security groups for Redis"
  type        = list(string)
}

variable "node_type" {
  description = "Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ (Replication Group)"
  type        = bool
  default     = false
}
