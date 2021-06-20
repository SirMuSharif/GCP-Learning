#########################################################################
### Networking

// Create the cloud network stack
module "google_cloud_networking" {
  // Module Source
  source                = "./modules/google_cloud/vpc"

  // Google Project Information
  google_project_id     = var.cloud_auth.google_project_id
  google_project_region = var.cloud_auth.google_project_region

  // Networking Settings
  vpc_name              = var.google_cloud.vpc_name
  vpc_public_subnets    = var.google_cloud.vpc_public_subnets
}

module "google_cloud_fw_ingress" {
  // Module Source
  source                = "./modules/google_cloud/firewall"

  // Google Project Information
  google_project_id     = var.cloud_auth.google_project_id
  google_project_region = var.cloud_auth.google_project_region

  // Firewall Settings
  name = var.google_cloud.ingress_rules.name
  network = module.google_cloud_networking.vpc_name
  direction = var.google_cloud.ingress_rules.direction
  target_tags = var.google_cloud.ingress_rules.target_tags

  // Allow Blocks
  allow_blocks = var.google_cloud.ingress_rules.allow_blocks
  
  // Deny Blocks
  // If you wanted to add deny blocks instead of (or in addition to) 
  // the apply_blocks up-top, you can do that here in the same style
  // data structure.
}


#########################################################################
### Virtual Machines

// Create the Google Cloud compute instances
module "google_cloud_compute" {
  // Module Source
  source                = "./modules/google_cloud/compute"

  // Google Project Information
  google_project_id     = var.cloud_auth.google_project_id
  google_project_region = var.cloud_auth.google_project_region

  // Compute Resources
  compute_nodes         = var.google_cloud.compute
  ssh_username          = var.ssh_auth.username
  ssh_pubkey            = var.ssh_auth.pubkey

  // The Virtual Machines cannot be created until the networking is available.
  depends_on = [
    module.google_cloud_networking
  ]
}
