// Create the Bastion VM on the PUBLIC subnet
resource "google_compute_instance" "bastion" {
  // Google Project to create the resources in
  project = var.google_project_id

  name = "bastion"
  machine_type = var.bastion_settings["vm_type"]
  zone = "${var.google_project_region}-a"

  tags = [ "k3s", "public" ]

  boot_disk {
    initialize_params {
      image = var.bastion_settings["host-os"]
      size  = var.bastion_settings["boot_disk_size"]
    }
  }

  network_interface {
    subnetwork = var.bastion_settings["network"]["subnetwork"]

    access_config {
      network_tier = var.bastion_settings["network"]["tier"]
    }
  }

  metadata = {
    sshKeys = "${var.ssh_username}:${var.ssh_pubkey}"
  }
}
