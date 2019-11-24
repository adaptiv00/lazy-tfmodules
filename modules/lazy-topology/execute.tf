
# Add ANY number of resources in this module
# But add them ALL as dependencies below

resource "null_resource" "execute" {
  provisioner "local-exec" {
    command = "echo Execute: ${var.module_name}, nodes: ${local.topology_json["node_count"]}"
  }

  depends_on = [
    null_resource.init,
  ]

  # Add this to other resources you want to execute when module dependecies change
  # This propagates when you use wait_for_taint, instead of wait_for
  triggers = {
    incoming_changes = local.change_trigger,
    topology_change = sha1(local.topology_base64)
  }
}

data "external" "loader" {
  program = ["/bin/bash", "${path.module}/bin/wrapper.sh"]
}

locals {
  topology_base64 = data.external.loader.result["topology"]
  topology_json = jsondecode(base64decode(local.topology_base64))
}

output "topology" {
  value       = local.topology_json
  description = "Cluster topology"
}