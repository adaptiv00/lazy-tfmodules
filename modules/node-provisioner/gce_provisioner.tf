resource "google_compute_disk" "disks_provisioner" {
    count = var.cloud == "gce" ? var.node_count : 0

    name            = format("%s-disk", element(var.node_names, count.index))
    type            = "pd-ssd"
    zone            = var.gce_zone
    size            = var.gce_disk_size_GB
    project         = var.gce_project_id
    labels          = { "serial" = format("%s-disk", element(var.node_names, count.index)) }
    image           = var.gce_base_image
}

locals {
  instance_types = length(var.instance_types) == 0 ? [for s in range(var.node_count) : var.default_gce_instance_type] : var.instance_types
}

resource "google_compute_instance" "gce_provisioner" {
    count = var.cloud == "gce" ? var.node_count : 0

    name            = element(var.node_names, count.index)
    machine_type    = local.instance_types[count.index]
    zone            = var.gce_zone
    project         = var.gce_project_id

    tags = ["all-apps"]

    boot_disk {
      source         = format("%s-disk", element(var.node_names, count.index))
    }

    # scratch_disk {
    #   interface = "NVME"
    # }

    # attached_disk {
    #   source          = "${format("%s-disk%02d", var.hostname_prefix, count.index+1)}"
    # }

    network_interface {
      network = "default"
      access_config {}
    }

    scheduling {
      preemptible = var.preemptible
      automatic_restart = "false"
    }

    depends_on = [
      google_compute_disk.disks_provisioner
    ]
}