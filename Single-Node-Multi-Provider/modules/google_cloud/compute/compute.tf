// Create Compute VM's with the definied settings.
resource "google_compute_instance" "compute_node" {
  // Loop through each of the compute nodes
  for_each = { for node in var.compute_nodes: node.name => node }

  // Google Project to create the resources in
  project       = var.google_project_id

  name          = each.value.name
  machine_type  = each.value.vm_type
  zone          = "${var.google_project_region}-${each.value.zone}"
  tags          = each.value.tags

  boot_disk {
    initialize_params {
      image = each.value.host_os
      size  = each.value.boot_disk_size
    }
  }

  network_interface {
    subnetwork = each.value.network.subnetwork
    access_config {
      network_tier = upper(each.value.network.tier)
    }
  }

  metadata = {
    sshKeys = "${var.ssh_username}:${var.ssh_pubkey}"
  }
}
