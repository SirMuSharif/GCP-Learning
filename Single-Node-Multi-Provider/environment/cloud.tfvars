cloud_auth = {
  // AWS
  aws_region  = "us-east-1"
  aws_profile = "default"

  // Google Cloud
  google_project_id     = "booming-tooling-291422"
  google_project_region = "us-east4"
}

ssh_auth = {
  username  = "danmanners"
  pubkey    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAngYLcPg5iIOgxoVae6JUr3gyqB4QBufth6oNc+II0D Dan Manners <daniel.a.manners@gmail.com>"
}

digitalocean = {
  droplets = [
    {
      name    = "tpi-k3s-do-edge"
      image   = "ubuntu-20-04-x64"
      region  = "nyc3"
      size    = "s-1vcpu-1gb"
    }
  ]
}

google_cloud = {
  "vpc_name" = "homelab-k3s"
  "vpc_public_subnets" = {
    "homelab-public-1a" = {
      ip_cidr_range = "10.46.0.0/23"
      description   = "Public facing subnet; first region."
    }
  },
  ingress_rules = {
    name = "k3s-ingress"
    direction = "ingress"
    target_tags = ["k3s"]
    allow_blocks = {
      icmp = {
        protocol = "icmp"
      }
      tcp = {
        protocol = "tcp"
        ports = ["22","80","443","2222","8443"]
      }
    }
  },
  compute = [
    {
      "name"            = "tpi-k3s-gcp-edge"
      "zone"            = "a"
      "vm_type"         = "e2-micro"
      "boot_disk_size"  = 20
      "host_os"         = "ubuntu-os-cloud/ubuntu-2004-lts"
      "network"         = {
        "subnetwork"    = "homelab-public-1a"
        "tier"          = "standard"
      }
      "tags"            = ["k3s"]
    }
  ] 
}

aws = {
  vpc = {
    cidr_block = "172.29.0.0/16"
  }
  subnets = {
    public = {
      "1a" = {
        name        = "1a"
        cidr_block  = "172.29.0.0/24"
      }
    }
  }
  compute = [
    {
      "name"              = "tpi-k3s-aws-edge"
      "instance_size"     = "t2.micro"
      "subnet_id"         = "1a"
      "root_volume_size"  = "20"
    }
  ]
  security_groups = {
    "k3s_ingress" = {
      "name" = "k3s_inbound_traffic"
      "description" = "Allows inbound traffic to the appropriate ports."
      "ingress" = [
        {
          "description" = "SSH Inbound"
          "port"        = 22
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTP Inbound"
          "port"        = 80
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTPS Inbound"
          "port"        = 443
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "SSH Alt Inbound"
          "port"        = 2222
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTPS Alt Inbound"
          "port"        = 8443
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        }
      ]
    }
  }
  tags = {
    environment   = "homelab"
    project_name  = "k3s-homelab"
  }
}