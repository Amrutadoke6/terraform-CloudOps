variable "aws_region" {
  default = "us-east-1"
}

variable "db_user" {
  description = "Database admin username"
  type        = string
}

variable "db_pass" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}
variable "project" {
  description = "Project name used across resources"
  type        = string
}

