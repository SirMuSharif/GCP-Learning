provider "aws" {
  region = var.auth.aws_region
  profile = var.auth.aws_profile
}

provider "digitalocean" {
  token = file("~/.digitalocean/token")
}

provider "google" {
  project = var.auth.google_project_id
  region  = var.auth.google_project_region
}
