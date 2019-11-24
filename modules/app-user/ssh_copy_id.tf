resource "null_resource" "ssh_copy_id" {

  connection {
    type             = "ssh"
    host             = element(var.public_ips, 0)
    user             = var.app_user
    password         = var.app_pass
    agent            = false
    timeout          = "60s"
  }

  provisioner "file" {
    source      = "${path.module}/bin/ssh-copy-id.sh"
    destination = "/tmp/ssh-copy-id.sh"
  }

   provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/ssh-copy-id.sh",
      "export APP_PASS=${var.app_pass}",
      "export APP_USER=${var.app_user}",
      "/tmp/ssh-copy-id.sh ${join(" ", var.node_names)}"
    ]
  }

  triggers = {
    incoming_changes = local.change_trigger
  }
  depends_on = [
    null_resource.init,
    null_resource.app_user,
    null_resource.app_sudo_rights,
    null_resource.ssh_keygen
  ]
}