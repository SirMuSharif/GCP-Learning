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
