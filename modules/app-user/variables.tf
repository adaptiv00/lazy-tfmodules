# Module input variables

variable "module_name" {
  default = "App User"
}

variable "node_count" {
  description = "How many servers"
}

# Cluster
variable "private_ips" {}
variable "public_ips" {}
variable "node_names" {}

# APP
variable "app_user" {}
variable "app_pass" {}
variable "app_uid" {}
variable "app_gid" {}

# SSH
variable "private_key" {}
variable "ssh_user" {}