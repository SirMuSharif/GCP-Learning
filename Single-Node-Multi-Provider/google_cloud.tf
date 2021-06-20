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
  vpc_public_subnets    = var.google_cloud.vpc_public_subnets
}

module "google_cloud_fw_ingress" {
  // Module Source
  source                = "./modules/google_cloud/firewall"

  // Google Project Information
  google_project_id     = var.cloud_auth.google_project_id
  google_project_region = var.cloud_auth.google_project_region

  // Firewall Settings
  name = "k3s-ingress"
  network = module.google_cloud_networking.vpc_name
  direction = "ingress" 
  target_tags = ["k3s"]

  // Allow Blocks
  allow_blocks = {
    icmp = {
      protocol = "icmp"
    }
    tcp = {
      protocol = "tcp"
      ports = ["80","443","2222","8443"]
    }
  }
  
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
  source                = "./modules/google_cloud/firewall"

  // Google Project Information
  google_project_id     = var.cloud_auth.google_project_id
  google_project_region = var.cloud_auth.google_project_region

  // Compute Resources
  k3s_settings          = var.google_cloud.compute
  ssh_username          = var.ssh_username
  ssh_pubkey            = var.ssh_pubkey

  // The Virtual Machines cannot be created until the networking is available.
  depends_on = [
    module.google_cloud_networking
  ]
}
