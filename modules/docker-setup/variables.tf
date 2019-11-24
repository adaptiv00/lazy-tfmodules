# Module input variables

variable "module_name" {
  default = "Docker Setup"
}

variable "node_count" {
  description = "How many servers"
}

variable "node_names" {}
variable "public_ips" {}
variable "app_user" {}
variable "docker_version" {
  description = "Docker version to install"
}

# Docker Hub, if registry mirror node is NOT EMPTY
variable "registry_mirror_port" {}

# SSH
variable "private_key" {}
variable "ssh_user" {}