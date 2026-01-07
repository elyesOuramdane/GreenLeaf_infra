variable "identifier" {
  description = "Identifier prefix for resources"
  type        = string
}

variable "elasticache_subnet_group_name" {
  description = "Name of the Elasticache subnet group"
  type        = string
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
