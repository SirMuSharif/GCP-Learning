// Create the INGRESS firewall for ingress TCP/22 and ICMP 
// for the Bastion and internal hosts.
resource "google_compute_firewall" "bastion" {
  // Google Project to create the resources in
  project = var.google_project_id

  name = "bastion-firewall"
  network = google_compute_network.vpc.name
  direction = "INGRESS"

  target_tags = var.target_tags

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = var.tcp_ingress
  }
}
