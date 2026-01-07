variable "identifier" {
  description = "Identifier prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to create mount targets in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security groups to attach to EFS mount targets"
  type        = list(string)
}
