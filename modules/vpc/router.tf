// Create a Router for our Private Subnets Egress
resource "google_compute_router" "nat_router" {
  // Google Project to create the resources in
  project = var.google_project_id

  name    = "outbound-nat-router"
  region   = var.google_project_region
  network = google_compute_network.vpc.id
  bgp {
    asn = 64514
  }
}

// Associate NAT to the previously created router
resource "google_compute_router_nat" "outbound_nat" {
  // Google Project to create the resources in
  project = var.google_project_id

  name                                = "outbound-nat-router"
  router                              = google_compute_router.nat_router.name
  region                              = google_compute_router.nat_router.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"

  // Use a Dynamic to create a list of ALL private CIDRs
  dynamic "subnetwork" {
    for_each = var.networking["vpc_private_subnets"]
    content {
      name = google_compute_subnetwork.private_subnet[subnetwork.key].id
      source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ] 
    }
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

