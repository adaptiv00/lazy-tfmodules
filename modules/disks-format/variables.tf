# Module input variables

variable "module_name" {
  default = "Disks Format"
}

# Module setup variables
variable "node_count" {}

# Cloud - we're only supporting GCE atm
variable "cloud" {}

# Cluster
variable "public_ips" {}

# APP
variable "app_user" {}
variable "runtime_folder" {}

# SSH
variable "private_key" {}
variable "ssh_user" {}