# Module input variables

variable "module_name" {
  default = "Provisioner"
}

variable "node_count" {
  description = "How many servers"
}

variable "node_names" {
  default     = []
  description = "List of length **server_count** above with the server/host names"
}

variable "cloud" {
  description = "What cloud?" //Possible values: gce, aws, onprem
}

// GCE config section, when cloud == gce

variable "gce_base_image" {
  default = "ubuntu-1604-xenial-v20181114"
}

variable "instance_types" {
  default = []
}

variable "default_gce_instance_type" { default = "n1-highcpu-4" }

variable "gce_zone" {
  default = "europe-west4-c"
}

variable "gce_project_id" {
  default = "kafka-provisioning"
}

variable "gce_disk_size_GB" {
  default = "50"
}

variable "preemptible" {
  default = "true"
}

// END GCE config section, when cloud == gce