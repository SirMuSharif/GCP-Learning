# Networking

This module creates the following resources:

* A network resource in a specified region
* 1 (or more) public facing subnets
* 1 (or more) private subnets
* A router for the private subnet region
* A NAT Gateway association for the private subnet region.
* An ingress firewall for bastion hosts
* An egress firewall for the k3s worker
