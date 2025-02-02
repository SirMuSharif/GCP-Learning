# PROVIDER | Google Project
google_project_id = "booming-tooling-291422"
google_project_region = "us-east4"

# Resources for SSH 
ssh_username = "danmanners"
ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAngYLcPg5iIOgxoVae6JUr3gyqB4QBufth6oNc+II0D Dan Manners <daniel.a.manners@gmail.com>"

networking = {
  "vpc_public_subnets" = {
    "homelab-public-1a" = {
      ip_cidr_range = "10.46.0.0/23"
      description = "Public facing subnet; first region."
    }
  },
  "vpc_private_subnets" = {
    "homelab-private-1a" = {
      ip_cidr_range = "10.46.100.0/23"
      description = "Private subnets; first region."
    }
  },
  private_subnets = [ "10.46.100.0/23" ]
}

bastion_settings = {
  "vm_type" = "e2-micro"
  "boot_disk_size" = 20
  "host-os" = "ubuntu-os-cloud/ubuntu-1804-lts"
  "network" = {
    "subnetwork" = "homelab-public-1a"
    "tier" = "STANDARD"
  }
}

k3s_settings = {
  "vm_type" = "e2-micro"
  "boot_disk_size" = 32
  "host-os" = "ubuntu-os-cloud/ubuntu-1804-lts"
  "network" = {
    "subnetwork" = "homelab-private-1a"
  }
}
# just testing Git