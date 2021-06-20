output "ipv4" {
  // For Each Compute node, output the Public IPv4 Address
  value = {
    for k, v in google_compute_instance.compute_node: k => v.network_interface.0.access_config.0.nat_ip
  }
}