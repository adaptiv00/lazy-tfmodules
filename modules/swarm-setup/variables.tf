# Module input variables

variable "module_name" {
  default = "Swarm Setup"
}

variable "node_count" {
  description = "How many servers"
}

variable "public_ips" {}
variable "private_ips" {}

# APP
variable "app_user" {}
variable "app_pass" {}