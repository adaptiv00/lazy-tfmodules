# Module input variables

variable "module_name" {
  default = "Aliases into /etc/hosts"
}

variable "node_count" {
  description = "How many servers"
}

variable "node_names" { }
variable "private_ips" { }
variable "public_ips" { }

variable "registry_internal_ip" {
  default     = ""
  description = "If left empty, the first node in list will be Docker registry"
}

# SSH
variable "private_key" {}
variable "ssh_user" {}
