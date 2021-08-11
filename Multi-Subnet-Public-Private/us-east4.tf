#########################################################################
### NETWORKING

module "networking" {
  source                = "./modules/vpc"
  google_project_id     = var.google_project_id
  google_project_region = var.google_project_region
  networking            = var.networking
}

#########################################################################
### Virtual Machines

module "virtual_machines" {
  source                = "./modules/compute"
  google_project_id     = var.google_project_id
  google_project_region = var.google_project_region
  bastion_settings      = var.bastion_settings
  k3s_settings          = var.k3s_settings
  ssh_username          = var.ssh_username
  ssh_pubkey            = var.ssh_pubkey

  // The Virtual Machines cannot be created until the networking is available.
  depends_on = [
    module.networking
  ]
}

#########################################################################
### OUTPUTS

output "bastion-public-ip" {
  value = module.virtual_machines.bastion.public_ip
}

output "k3s-worker-private-ip" {
  value = module.virtual_machines.k3s_worker.private_ip
}

output "proxyjump_command" {
  value = "ssh -qJ ${var.ssh_username}@${module.virtual_machines.bastion.public_ip} ${var.ssh_username}@${module.virtual_machines.k3s_worker.private_ip}"
}

# just testing git