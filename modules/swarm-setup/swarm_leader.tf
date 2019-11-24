resource "null_resource" "swarm_leader" {

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
      "docker swarm leave --force >/dev/null",
      "docker swarm init --advertise-addr ${element(var.private_ips, 0)}",
      "export TOKEN=$(docker swarm join-token manager -q)",
    ]
  }

  triggers = {
    incoming_changes = local.change_trigger
  }
  depends_on = [ null_resource.init ]
}