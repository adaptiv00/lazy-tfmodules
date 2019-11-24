resource "null_resource" "swarm_manager" {

  count = var.node_count - 1

  connection {
    type             = "ssh"
    host             = element(var.public_ips, count.index+1)
    user             = var.app_user
    password         = var.app_pass
    agent            = false
    timeout          = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      "export TOKEN=$(DOCKER_HOST=${var.private_ips[0]} docker swarm join-token manager -q)",
      "docker swarm leave --force >/dev/null",
      "docker swarm join ${var.private_ips[0]}:2377 --token $TOKEN --advertise-addr ${var.private_ips[count.index+1]}",
    ]
  }

  triggers = {
    incoming_changes = local.change_trigger
  }
  depends_on = [ null_resource.init, null_resource.swarm_leader ]
}