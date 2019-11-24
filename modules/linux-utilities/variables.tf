# Module input variables

variable "module_name" {
  default = "Linux Utilities"
}

variable "node_count" {
  description = "How many servers"
}

# Cluster
variable "public_ips" {}

# Packages
variable "install_packages" { default = "" }

# SSH
variable "private_key" {}
variable "ssh_user" {}