cloud_auth = {
  // AWS
  aws_region = "us-east-1"
  aws_profile = "default"

  // Google Cloud
  google_project_id = "booming-tooling-291422"
  google_project_region = "us-east4"
}

ssh_auth = {
  pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAngYLcPg5iIOgxoVae6JUr3gyqB4QBufth6oNc+II0D Dan Manners <daniel.a.manners@gmail.com>"
}

digitalocean = {
  droplets = [
    {
      name = "tpi-k3s-do-edge"
      image = "ubuntu-20-04-x64"
      region = "nyc3"
      size  = "s-1vcpu-1gb"
    }
  ]
}

