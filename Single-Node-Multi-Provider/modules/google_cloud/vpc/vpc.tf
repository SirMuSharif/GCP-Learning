// Create the VPC
resource "google_compute_network" "vpc" {
  // Google Project to create the resources in
  project = var.google_project_id

  name                    = "vpc-network"
  auto_create_subnetworks = false
}

// Create the Public Subnets
resource "google_compute_subnetwork" "public_subnet" {
  // Google Project to create the resources in
  project = var.google_project_id
  // For each defined Public-facing subnet
  for_each = { for k,v in var.networking["vpc_public_subnets"] : k => v }

  name     = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region   = var.google_project_region
  network  = google_compute_network.vpc.id
}
