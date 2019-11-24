# Module input variables

variable "module_name" {
  default = "Registry Mirror"
}

variable "registry_mirror_node" { default = "" }
variable "registry_mirror_port" { }
variable "registry_parent_folder" { }
variable "docker_hub_username" { default = "" }
variable "docker_hub_password" { default = "" }

# SSH
variable "private_key" {}
variable "ssh_user" {}

#APP
variable "app_user" {}