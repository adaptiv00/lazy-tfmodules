
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}, instances created: ${var.node_count}"
  }

  depends_on = [
    null_resource.init, google_compute_instance.gce_provisioner
  ]

  # Add this to other resources you want to execute when module dependecies change
  # This propagates when you use wait_for_taint, instead of wait_for
  triggers = {
    incoming_changes = local.change_trigger
  }
}

locals {
  all_public_ips   = google_compute_instance.gce_provisioner.*.network_interface.0.access_config.0.nat_ip
  all_private_ips  = google_compute_instance.gce_provisioner.*.network_interface.0.network_ip
  all_host_names   = google_compute_instance.gce_provisioner.*.name
}

output "public_ips" {
  value = local.all_public_ips
}

output "private_ips" {
  value = local.all_private_ips
}

output "node_names" {
  value = local.all_host_names
}