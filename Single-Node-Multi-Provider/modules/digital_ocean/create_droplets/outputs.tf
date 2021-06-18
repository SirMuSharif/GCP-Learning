output "ipv4" {
  // For Each Droplet, output the IPv4 Address
  value = {
    for k, v in digitalocean_droplet.node: k => v.ipv4_address
  }
}