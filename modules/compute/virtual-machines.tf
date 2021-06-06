// Create the Bastion VM on the PUBLIC subnet
resource "google_compute_instance" "bastion" {
  // Google Project to create the resources in
  project = var.google_project_id

  name = "bastion"
  machine_type = var.bastion_settings["vm_type"]
  zone = "${var.google_project_region}-a"

  tags = [ "bastion", "public" ]

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

// Create the internal VM for K3s on the PRIVATE subnet
resource "google_compute_instance" "k3s_worker" {
  // Google Project to create the resources in
  project = var.google_project_id

  name = "k3s-worker"
  machine_type = var.k3s_settings["vm_type"]
  zone = "${var.google_project_region}-a"

  tags = [ "k3s", "private" ]

  boot_disk {
    initialize_params {
      image = var.k3s_settings["host-os"]
      size  = var.k3s_settings["boot_disk_size"]
    }
  }

  network_interface {
    subnetwork = var.k3s_settings["network"]["subnetwork"]
  }

  metadata = {
    sshKeys = "${var.ssh_username}:${var.ssh_pubkey}"
  }
}
