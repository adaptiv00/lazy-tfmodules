
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

  connection {
    type             = "ssh"
    host             = var.registry_mirror_node
    private_key      = file(var.private_key)
    user             = var.ssh_user
    agent            = false
    timeout          = "60s"
  }

  provisioner "file" {
    content     = templatefile("${path.module}/conf/registry-mirror.yml.tmpl", {
      docker_hub_username = var.docker_hub_username,
      docker_hub_password = var.docker_hub_password,
      registry_mirror_port = var.registry_mirror_port
    })
    destination = "/tmp/registry-mirror.yml"
  }

  provisioner "file" {
    source      = "${path.module}/bin/mirror-start.sh"
    destination = "/tmp/mirror-start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mirror-start.sh",
      "sudo rm -Rf ${local.registry_mirror_folder}",
      "sudo mkdir -p ${local.registry_mirror_folder}",
      "sudo chown -R ${var.app_user}:${var.app_user} ${var.registry_parent_folder}",
      "sudo chown -R ${var.ssh_user}:${var.ssh_user} ${local.registry_mirror_folder}",
      "sudo mv /tmp/registry-mirror.yml ${local.registry_mirror_folder}/",
      "export REGISTRY_FOLDER=\"${local.registry_mirror_folder}\"",
      ". /tmp/mirror-start.sh"
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

locals {
  registry_mirror_folder = "${var.registry_parent_folder}/.registry-mirror"
}