
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

  count = var.install_packages != "" ? var.node_count : 0

  connection {
    type             = "ssh"
    host             = element(var.public_ips, count.index)
    private_key      = file(var.private_key)
    user             = var.ssh_user
    agent            = false
    timeout          = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -qq && sudo apt-get install -y -qq --no-install-recommends ${var.install_packages}"
    ]
  }

  depends_on = [
    null_resource.init,
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