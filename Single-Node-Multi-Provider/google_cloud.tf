#########################################################################
### Networking

// Create the Network stack
# module "google_cloud_networking" {
#   source                = "./modules/google_cloud/vpc"
#   google_project_id     = var.cloud_auth.google_project_id
#   google_project_region = var.cloud_auth.google_project_region
#   networking            = var.networking
# }

#########################################################################
### Virtual Machines

# module "google_cloud_compute" {
#   source                = "./modules/google_cloud/compute"
#   google_project_id     = var.cloud_auth.google_project_id
#   google_project_region = var.cloud_auth.google_project_region
#   k3s_settings          = var.google_cloud.compute
#   ssh_username          = var.ssh_username
#   ssh_pubkey            = var.ssh_pubkey

#   // The Virtual Machines cannot be created until the networking is available.
#   depends_on = [
#     module.google_cloud_networking
#   ]
# }
