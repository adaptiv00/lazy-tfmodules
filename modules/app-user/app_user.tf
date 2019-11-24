resource "null_resource" "app_user" {

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
    source      = "${path.module}/bin/app-user.sh"
    destination = "/tmp/app-user.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/app-user.sh",
      "/tmp/app-user.sh ${var.app_user} ${var.app_pass} ${var.app_uid} ${var.app_gid}"
    ]
  }

  # This causes a cycle with destroy
  # provisioner "remote-exec" {
  #  when = "destroy"

  #  inline = [
  #    "sudo userdel -r ${var.app_user}"
  #  ]

  #  on_failure = "continue"
  # }

  depends_on = [ null_resource.init ]
  # Don't create once created
  # triggers = {
  #  incoming_changes = local.change_trigger
  # }
}