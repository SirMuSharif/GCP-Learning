// Create a Droplet for each of the droplets specified
resource "digitalocean_droplet" "node" {
  for_each = { for droplet in var.droplets: droplet.name => droplet }

  name   = each.value.name
  image  = each.value.image
  region = each.value.region
  size   = each.value.size

  ssh_keys = var.pubkey_ids

}
