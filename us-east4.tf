###############################################################################
### NETWORKING
resource "google_compute_network" "vpc" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  for_each = { for k,v in var.networking["vpc_public_subnets"] : k => v }
  name     = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region   = var.google_project_region
  network  = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "private_subnet" {
  for_each = { for k,v in var.networking["vpc_private_subnets"] : k => v }
  name     = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region   = var.google_project_region
  network  = google_compute_network.vpc.id
}

resource "google_compute_router" "nat_router" {
  name    = "outbound-nat-router"
  region   = var.google_project_region
  network = google_compute_network.vpc.id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "outbound_nat" {
  name                                = "outbound-nat-router"
  router                              = google_compute_router.nat_router.name
  region                              = var.google_project_region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.networking["vpc_private_subnets"]
    content {
      name = google_compute_subnetwork.private_subnet[subnetwork.key].id
      source_ip_ranges_to_nat = [ subnetwork.value.ip_cidr_range ] 
    }
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

###############################################################################
### FIREWALL
resource "google_compute_firewall" "bastion" {
  name = "bastion-firewall"
  network = google_compute_network.vpc.name
  direction = "INGRESS"

  target_tags = [ "bastion", "k3s" ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

resource "google_compute_firewall" "k3s_worker" {
  name = "k3s-worker"
  network = google_compute_network.vpc.name
  direction = "EGRESS"
  destination_ranges = [ "0.0.0.0/0" ]

  target_tags = [ "k3s" ]

  allow {
    protocol = "tcp"
    ports = [ "0-65535" ]
  }
}

###############################################################################
### Virtual Machines
resource "google_compute_instance" "bastion" {
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

resource "google_compute_instance" "k3s_worker" {
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

###############################################################################
### OUTPUTS

output "bastion_public_ip_address" {
  value = google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip
}

output "k3s_worker_private_ip_address" {
  value = google_compute_instance.bastion.network_interface.0.network_ip
}
