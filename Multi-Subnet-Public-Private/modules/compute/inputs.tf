// Project and Region
variable "google_project_id" {
  description = "Name for the Google Project to apply resources to."
}
variable "google_project_region" {
  description = "Region for the primary Google Project to apply resources to."
}

// Virtual Machine Settings
variable "bastion_settings" {
  description = "All Bastion Compute settings."
}
variable "k3s_settings" {
  description = "All K3s worker compute settings."
}

// SSH Settings
variable "ssh_username" {
  description = "Username for the SSH public key to authenticate with."
}
variable "ssh_pubkey" {
  description = "The SSH Public Key to install onto cloud hosts for remote access."
}
