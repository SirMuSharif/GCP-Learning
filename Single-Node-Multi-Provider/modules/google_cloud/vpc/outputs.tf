output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "public_subnet_ids" {
  value = {
    for k, v in google_compute_subnetwork.public_subnet: k => v.id
  }
}