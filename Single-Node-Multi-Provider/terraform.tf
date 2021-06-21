terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    google = {
      source = "hashicorp/google"
      version = "3.72.0"
    }

    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "gcs" {
    bucket  = "dm-homelab-tfstate"
    prefix  = "multi-cloud/state"
  }
}
