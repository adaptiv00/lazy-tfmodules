# Generate the ssh key for the leader host, install sshpass for the
# subsequent ssh-copy-id

resource "null_resource" "ssh_keygen" {

  connection {
    type             = "ssh"
    host             = element(var.public_ips, 0)
    user             = var.app_user
    password         = var.app_pass
    agent            = false
    timeout          = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa"
    ]
  }

  # No need for change, once generated
  # triggers = {
  #  incoming_changes = local.change_trigger
  # }
  depends_on = [ null_resource.init, null_resource.app_user, null_resource.app_sudo_rights ]
}