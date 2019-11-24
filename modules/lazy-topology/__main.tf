
# !!! Do NOT CHANGE this file !!!
# It's boilerplate for module dependency
# See execute.tf to add you business logic

resource "null_resource" "init" {
  provisioner "local-exec" {
    command = "echo Init ${var.module_name}, waiting: #${length(var.wait_for)}"
  }

  triggers = {
    incoming_changes = local.change_trigger
  }
}

resource "null_resource" "done" {
  depends_on = [ null_resource.execute ]

  triggers = {
    incoming_changes = local.change_trigger
  }
}

output "status_done" {
  value = sha1(join(" ", [
    null_resource.init.id,
    null_resource.execute.id,
    null_resource.done.id,
    local.topology_base64
  ]))
}

locals {
  change_trigger = sha1(join(" ", var.wait_for_taint))
}

variable "wait_for" { default = [ "none" ] }
variable "wait_for_taint" { default = [ "none" ] }