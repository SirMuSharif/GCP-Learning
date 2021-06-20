# Multi-Cloud Public K3s Nodes

Wanted to throw together an example of how someone might spin up Edge Cloud K3s nodes in multiple cloud environments at once!

## Requirements & Expectations

* AWS Account & API Keys
* GCP Account & API Keys
* DigitalOcean Account & API Keys

## To-Do

* [ ] General
  * [x] Create per-Cloud Provider files in this root directory
  * [ ] Document how to fill out the environment variables file
  * [ ] Create documentation on **why** things are laid out the way they are
  * [ ] Document all of the {required tools,binaries,applications,etc} to get this running if you're not [me](mailto:daniel.a.manners@gmail.com)
  * [ ] Update this `README` file to include how to setup, teardown, and generally use this repository.
* [ ] Digital Ocean
  * [x]  Create an SSH-Public Key Resource Module
  * [x]  Create a multi-droplet creation module
  * [x]  Get `user-data` template creation working
  * [x]  Ensure that a user created with `user-data` can authenticate with their SSH Keypair
  * [ ]  Document how to use the multi-droplet creation module
* [ ] Google Cloud
  * [x] Create a network provisioning module
  * [ ] Create a mutli-Compute creation module
  * [ ] Ensure that `user-data` works as expected
  * [ ] Document how to use both modules
* [ ] AWS
  * [ ] Create a VPC/network provisioning module
  * [ ] Create a multi-EC2 creation module
  * [ ] Ensure that `user-data` works as expected
  * [ ] Document how to use both modules
