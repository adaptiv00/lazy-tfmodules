
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}"
  }

  count = var.cloud == "gce" ? var.node_count : 0

  connection {
    type             = "ssh"
    host             = element(var.public_ips, count.index)
    private_key      = file(var.private_key)
    user             = var.ssh_user
    agent            = false
    timeout          = "60s"
  }

  provisioner "file" {
    source      = "${path.module}/bin/disks_setup.sh"
    destination = "/tmp/disks_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/disks_setup.sh",
      "/bin/bash -c \"export APP_USER=${var.app_user} && . /tmp/disks_setup.sh\"",
      "mount | grep '${var.app_user}' | awk '{print $3}' | xargs -I {} sudo chown -R ${var.app_user}:${var.app_user} {}",
      "sudo mkdir -p /mnt/${var.app_user}",
      "sudo chown -R ${var.app_user}:${var.app_user} /mnt/${var.app_user}",
      "sudo mkdir -p ${var.runtime_folder}",
      "sudo chown -R ${var.app_user}:${var.app_user} ${var.runtime_folder}"
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