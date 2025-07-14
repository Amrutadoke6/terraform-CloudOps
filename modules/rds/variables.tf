variable "project" {
  description = "Project name prefix for tagging and naming"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_user" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_pass" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

