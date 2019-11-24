
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

  depends_on = [
    null_resource.init,
    null_resource.app_user,
    null_resource.app_sudo_rights,
    null_resource.ssh_keygen,
    null_resource.ssh_copy_id
  ]

  # Add this to other resources you want to execute when module dependecies change
  # This propagates when you use wait_for_taint, instead of wait_for
  triggers = {
    incoming_changes = local.change_trigger
  }
}

output "sample_output" {
  value       = "your module output"
  description = "Add your outputs here, as many as needed"
}