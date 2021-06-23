# Multi-Cloud Public K3s Nodes

Wanted to throw together an example of how someone might spin up Edge Cloud K3s nodes in multiple cloud environments at once!

## Requirements & Expectations

* AWS Account & API Keys
* GCP Account & API Keys
* DigitalOcean Account & API Keys
* Terraform
* Google SDK tools
* AWS CLI
* Terraform State Backend Configured (optional)

## Deployment Notes

* t3.micro (1vCPU, 1GiB Memory) instances, or equivalent for the other cloud providers, will often choke with just Zerotier and basic daemonsets running on k3s within ~15-20m of uptime. If you want to actually use the hosts, you'll likely need at least 1vCPU and 2GiB memory.

## How to deploy everything

Due to needing to associate the security groups for AWS, this needs to be a multi-stage install. Luckily, once this is done the **FIRST** time only, you can run it normally every time after.

```bash
# Initialize Everything
terraform init

# First Terraform run; make sure this looks correct
terraform plan -var-file="environment/cloud.tfvars" \
  -target=module.aws_vpc \
  -target=module.aws_compute \
  -target=module.aws_k3s_security_groups

# If we're good, run the same command above but as `terraform apply`

# Every Subsequent Run
terraform plan -var-file="environment/cloud.tfvars"
```

## Installing ZeroTier on each host

This is a hacky way without using Ansible/Puppet Bolt to get things installed and set up on each host:

```bash
# Loop through everything; make sure to set the right username
for resource in $(terraform output | grep "tpi" | awk '{gsub(/"/,""); print $1","$3}' | xargs echo -n); do
  # Set your SSH Username below
  SSH_USER="danmanners"
  # Set your Zerotier Network ID below
  ZT_NETID="NOT_REAL_ZEROTIER_ID"
  # Break apart the variables from their comma-separated values
  CLOUD_HOST="$(echo "$resource" | awk -F, '{print $1}')"
  CLOUD_IP="$(echo "$resource" | awk -F, '{print $2}')"

  # Set the hostname for the host
  ssh $SSH_USER@$CLOUD_IP -t "sudo hostnamectl set-hostname --static $CLOUD_HOST"
  # Install Zerotier
  ssh $SSH_USER@$CLOUD_IP -t "curl -s https://install.zerotier.com | sudo bash"
  # Request host joins to Zerotier Network; use the Zerotier console to label and approve each of the nodes
  ssh $SSH_USER@$CLOUD_IP -t "sudo zerotier-cli join $ZT_NETID"
  # Add DNS to the ZeroTier hosts on their ZT interfaces
  ssh $SSH_USER@$CLOUD_IP -t 'sudo systemd-resolve -i $(ip l show | grep zt | awk '\''{gsub(/:/,""); print $2}'\'') --set-dns=10.45.0.1'
  # Install K3s
  ssh $SSH_USER@$CLOUD_IP -t "sudo wget https://github.com/k3s-io/k3s/releases/download/v1.21.0%2Bk3s1/k3s \
    -O /usr/local/bin/k3s && \
    sudo chmod a+x /usr/local/bin/k3s"
done

# Next, copy over the systemd file, Install the K3s Service File,
# Get the Flannel Iface argument to add to the k3s service
ip l show | grep zt | awk '{gsub(/:/,""); print "--flannel-iface "$2}'
# Add the output to the ExecStart in the systemd file
sudo systemctl daemon-reload
sudo systemctl enable --now k3s-node

# This should ultimately be replaced with a YAML Config at /etc/rancher/k3s/config.yaml and a DRY systemd file.
```

## Destroying all of the created resources

We can simply tear down all of the resources by running the following command:

```bash
terraform destroy -var-file="environment/cloud.tfvars"
```

## To-Do

* [ ] General
  * [x] Create per-Cloud Provider files in this root directory
  * [ ] Document how to fill out the environment variables file
  * [ ] Document **why** things are laid out the way they are
  * [x] Document all of the {required tools,binaries,applications,etc} to get this running if you're not [me](mailto:daniel.a.manners@gmail.com)
  * [ ] Update this `README` file to include how to setup, teardown, and generally use this repository
* [ ] Digital Ocean
  * [x]  Create an SSH-Public Key Resource Module
  * [x]  Create a multi-droplet creation module
  * [x]  Get `user-data` template creation working
  * [x]  Ensure that a user created with `user-data` can authenticate with their SSH Keypair
  * [ ]  Document how to use the multi-droplet creation module
* [ ] Google Cloud
  * [x] Create a network provisioning module
  * [x] Create a mutli-Compute creation module
  * [x] Ensure that `user-data` works as expected
  * [ ] Document how to use both modules
* [ ] AWS
  * [x] Create a VPC/network provisioning modules
  * [x] Create a multi-EC2 creation module
  * [x] Ensure that `user-data` works as expected
  * [ ] Document how to use both modules
