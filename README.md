# Learning Google Cloud

I have extensive knowledge of AWS, but I have done damn near _nothing_ with Google Cloud thus far.

As I've been doing a **lot** with Terraform recently, I have been finding myself (perhaps incorrectly) "How hard can it be to pivot from AWS to GCP?"

I guess I'll find out soon! 🙂

## How to run everything

1. Replace your variables in `environment/cloud.tfvars` with the relevant and appropriate values for your environment.
2. Run `terraform plan -var-file="environment/cloud.tfvars"` to check the plan.
3. Run `terraform apply -var-file="environment/cloud.tfvars"` to create the resources.
