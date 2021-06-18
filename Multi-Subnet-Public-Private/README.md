# Learning Google Cloud

I have extensive knowledge of AWS, but I have done damn near _nothing_ with Google Cloud thus far.

As I've been doing a **lot** with Terraform recently, I have been finding myself (perhaps incorrectly) "How hard can it be to pivot from AWS to GCP?"

I guess I'll find out soon! 🙂

## Requirements & Expectations

* [Install the Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* Log into your Google Cloud account in your terminal **BEFORE** continuing.

## How to run everything

First, we'll need to make sure that we create a bucket for our state-file ahead of time.

```bash
gsutil mb -p "$google_project_id" -l "$region" -b on gs://$unique_bucket_name
```

Then, make sure that you edit the `provider.tf` file and change the Terraform GCS bucket name to match the `$unique_bucket_name`.

Then, you can proceed into creating all of the infrastructure.

1. Replace your variables in `environment/cloud.tfvars` with the relevant and appropriate values for your environment.
2. Run `terraform init`
3. Run `terraform plan -var-file="environment/cloud.tfvars"` to check the plan.
4. Run `terraform apply -var-file="environment/cloud.tfvars"` to create the resources.

## How to tear it all down

1. Run `terraform destroy -var-file="environment/cloud.tfvars"`

If it fails the first time, run it a second (or third) time.

## Random things that were a bit challenging

* I'm definitely not a huge fan of how Google Cloud handles Ingress/Egress firewalls vs Security Groups, but perhaps I'll come to love it.

## To-Do

* Add a Load Balancer [https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule]

## References

* [Adding SSH Keys in VM Metadata](https://github.com/hashicorp/terraform/issues/6678)
* [Terraform Compute Reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/)
* [Terraform Dynamics](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html); used for the NAT Router section
