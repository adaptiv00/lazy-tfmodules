
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

  count = var.node_count

  connection {
    type             = "ssh"
    host             = element(var.public_ips, count.index)
    private_key      = file(var.private_key)
    user             = var.ssh_user
    agent            = false
    timeout          = "60s"
  }

  provisioner "file" {
    source      = "${path.module}/bin/hosts-setup.sh"
    destination = "/tmp/hosts-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/hosts-setup.sh",
      "/tmp/hosts-setup.sh ${local.registry_internal_ip} ${join(" ", var.private_ips)} ${join(" ", var.node_names)}"
    ]
  }

  depends_on = [
    null_resource.init,
  ]

  # Add this to other resources you want to execute when module dependecies change
  # This propagates when you use wait_for_taint, instead of wait_for
  triggers = {
    incoming_changes = local.change_trigger
    registry_ip = local.registry_internal_ip
  }
}

locals {
  registry_internal_ip = var.registry_internal_ip == "" ? element(var.private_ips, 0) : var.registry_internal_ip
}