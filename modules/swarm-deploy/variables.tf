# Module input variables

variable "module_name" {
  default = "Swarm Deploy"
}

# Nodes
variable "public_ips" {}

# Deployment
variable "deploy_folder" {}
variable "stack_names" {}
variable "deploy_file_name" {}
variable "full_erase" {}

# App
variable "app_user" {}
variable "app_pass" {}
