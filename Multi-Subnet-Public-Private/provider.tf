terraform {
  backend "gcs" {
    bucket  = "dm-homelab-tfstate"
    prefix  = "terraform/state"
  }
}

provider "google" {
  # Project Name is Set
  project     = var.google_project_id
  region      = var.google_project_region
}
# just testing git