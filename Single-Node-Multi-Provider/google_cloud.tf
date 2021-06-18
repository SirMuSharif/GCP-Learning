// Create the Network stack
# module "google_cloud_networking" {
#   source                = "./modules/google_cloud/vpc"
#   google_project_id     = var.google_project_id
#   google_project_region = var.google_project_region
#   networking            = var.networking
# }

#########################################################################
### Virtual Machines

# module "google_cloud_compute" {
#   source                = "./modules/google_cloud/compute"
#   google_project_id     = var.google_project_id
#   google_project_region = var.google_project_region
#   bastion_settings      = var.bastion_settings
#   k3s_settings          = var.k3s_settings
#   ssh_username          = var.ssh_username
#   ssh_pubkey            = var.ssh_pubkey

#   // The Virtual Machines cannot be created until the networking is available.
#   depends_on = [
#     module.google_cloud_networking
#   ]
# }
