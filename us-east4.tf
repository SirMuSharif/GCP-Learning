#########################################################################
### NETWORKING
// Create the VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

// Create the Public Subnets
resource "google_compute_subnetwork" "public_subnet" {
  for_each = { for k,v in var.networking["vpc_public_subnets"] : k => v }
  name     = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region   = var.google_project_region
  network  = google_compute_network.vpc.id
}

// Create the Private Subnets
resource "google_compute_subnetwork" "private_subnet" {
  for_each = { for k,v in var.networking["vpc_private_subnets"] : k => v }
  name     = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region   = var.google_project_region
  network  = google_compute_network.vpc.id
}

// Create a Router for our Private Subnets Egress
resource "google_compute_router" "nat_router" {
  name    = "outbound-nat-router"
  region   = var.google_project_region
  network = google_compute_network.vpc.id
  bgp {
    asn = 64514
  }
}

// Associate NAT to the previously created router
resource "google_compute_router_nat" "outbound_nat" {
  name                                = "outbound-nat-router"
  router                              = google_compute_router.nat_router.name
  region                              = var.google_project_region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"

  // Use a Dynamic to create a list of ALL private CIDRs
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

#########################################################################
### FIREWALL
// Create the INGRESS firewall for ingress TCP/22 and ICMP 
// for the Bastion and internal hosts.
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

// Create the EGRESS firewall for the internal K3s workers to 
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

#########################################################################
### Virtual Machines
// Create the Bastion VM on the PUBLIC subnet
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

// Create the internal VM for K3s on the PRIVATE subnet
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
