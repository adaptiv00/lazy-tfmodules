resource "null_resource" "docker_setup" {

  count = var.node_count

  connection {
    type             = "ssh"
    host             = element(var.public_ips, count.index)
    private_key      = file(var.private_key)
    user             = var.ssh_user
    agent            = false
    timeout          = "60s"
  }

  provisioner "local-exec" {
    command = "echo Setting up Docker '${var.docker_version}' on: ${element(var.public_ips, count.index)}"
  }

  provisioner "file" {
    content     = templatefile("${path.module}/config/daemon.json.tmpl", {
      node_name = element(var.node_names, count.index)
      registry_mirror_port = var.registry_mirror_port
    })
    destination = "/tmp/daemon.json"
  }

  provisioner "file" {
    content     = templatefile("${path.module}/config/docker.conf.tmpl", {
      api_host  = element(var.private_ips, count.index)
    })
    destination = "/tmp/docker.conf"
  }

  provisioner "file" {
    source      = "${path.module}/bin/docker-setup.sh"
    destination = "/tmp/docker-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "export VERSION='${var.docker_version}'",
      "export APP_USER='${var.app_user}'",
      "export SSH_USER='${var.ssh_user}'",
      "chmod +x /tmp/docker-setup.sh",
      ". /tmp/docker-setup.sh"
    ]
  }

  triggers = {
    incoming_changes = local.change_trigger
  }
  depends_on = [ null_resource.init ]

}