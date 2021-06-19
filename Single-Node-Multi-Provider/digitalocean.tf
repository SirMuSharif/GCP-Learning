#########################################################################
### SSH PubKeys

module "do_ssh_pubkey" {
  // Module Source
  source = "./modules/digital_ocean/add_ssh_pubkey"
  ssh_pubkey = var.ssh_auth.pubkey
}


#########################################################################
### Virtual Machines

// Create the DigitalOcean Droplets
module "do_droplets" {
  // Module Source
  source = "./modules/digital_ocean/create_droplets"
  droplets = var.digitalocean.droplets
  pubkey_ids = toset([module.do_ssh_pubkey.pubkey_id])

  // SSH Information
  ssh_username  = var.ssh_auth.username
  ssh_pubkey    = var.ssh_auth.pubkey

  // Depends On
  depends_on = [
    module.do_ssh_pubkey
  ]
}

