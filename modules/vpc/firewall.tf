// Create the INGRESS firewall for ingress TCP/22 and ICMP 
// for the Bastion and internal hosts.
resource "google_compute_firewall" "bastion" {
  // Google Project to create the resources in
  project = var.google_project_id

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
  // Google Project to create the resources in
  project = var.google_project_id

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
