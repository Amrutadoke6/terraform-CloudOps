variable "project" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "sg_id" {}
variable "instance_profile_name" {}
