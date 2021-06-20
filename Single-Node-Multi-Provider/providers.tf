provider "aws" {
  // Ensure that you've set up your ~/.aws/credentials.conf file.
  // Set the region and profile name here.
  region = var.cloud_auth.aws_region
  profile = var.cloud_auth.aws_profile
}

provider "digitalocean" {
  // Put your Digital Ocean API Token in a file at this location.
  // The 'chomp' function will remove any newlines in the file.
  token = chomp(file("~/.digitalocean/token"))
}

provider "google" {
  // Ensure you set your Google Project ID and Region here.
  project = var.cloud_auth.google_project_id
  region  = var.cloud_auth.google_project_region
}
