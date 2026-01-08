variable "db_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "magento_admin_firstname" {
  description = "Magento Admin First Name"
  type        = string
  default     = "Admin"
}

variable "magento_admin_lastname" {
  description = "Magento Admin Last Name"
  type        = string
  default     = "User"
}

variable "magento_admin_email" {
  description = "Magento Admin Email"
  type        = string
  default     = "admin@example.com"
}

variable "magento_admin_user" {
  description = "Magento Admin Username"
  type        = string
  default     = "admin"
}

variable "magento_admin_password" {
  description = "Magento Admin Password"
  type        = string
  sensitive   = true
}
