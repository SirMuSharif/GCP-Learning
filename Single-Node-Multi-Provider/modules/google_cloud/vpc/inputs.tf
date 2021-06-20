// Project and Region
variable "google_project_id" {
  description = "Name for the Google Project to apply resources to."
}
variable "google_project_region" {
  description = "Region for the primary Google Project to apply resources to."
}

// Networking Stack
variable "vpc_public_subnets" {
  description = "The full networking stack. Describes everything necessary for the VPC."
}
