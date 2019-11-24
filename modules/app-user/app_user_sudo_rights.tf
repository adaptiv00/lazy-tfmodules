resource "null_resource" "app_sudo_rights" {

  count = var.node_count

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
      "sudo usermod -aG sudo ${var.app_user}"
    ]
  }

  depends_on = [ null_resource.init, null_resource.app_user ]
  triggers = {
    incoming_changes = local.change_trigger
  }
}