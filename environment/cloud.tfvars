# PROVIDER | Google Project
google_project_id = "booming-tooling-291422"

# Resources for SSH 
ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAngYLcPg5iIOgxoVae6JUr3gyqB4QBufth6oNc+II0D Dan Manners <daniel.a.manners@gmail.com>"

inbound_access = {
  tcp_ports = {
    http  = "80"
    https = "443"
    ssh   = "122"
  }
}