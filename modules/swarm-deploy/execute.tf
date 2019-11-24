
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

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
      "rm -Rf ${local.remote_deploy_folder}"
    ]
  }

  provisioner "file" {
    source = var.deploy_folder
    destination = "/home/${var.app_user}"
  }

  # provisioner "file" {
  #  source = "${path.module}/bin/deploy.sh"
  #  destination = "${local.remote_deploy_folder}/deploy.sh"
  # }

  provisioner "remote-exec" {
  inline = [
    <<EOT
    /bin/bash -c '
      chmod +x ${local.remote_deploy_folder}/${var.deploy_file_name} && \
      export FULL_ERASE="${var.full_erase}" && \
      export STACK_NAMES="${join(" ", var.stack_names)}" && \
      export DEPLOY_FOLDER="${var.deploy_folder}" && \
      . ${local.remote_deploy_folder}/${var.deploy_file_name}
    '
    EOT
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
  remote_deploy_folder = "/home/${var.app_user}/${var.deploy_folder}"
}