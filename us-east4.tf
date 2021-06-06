resource "google_compute_network" "vpc" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  for_each = { for k,v in var.networking["vpc_public_subnets"] : k => v }

  name = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region = var.google_project_region
  network = google_compute_network.vpc.id
}