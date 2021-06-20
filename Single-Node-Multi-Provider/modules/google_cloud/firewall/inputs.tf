variable "google_project_id" {}
variable "google_project_region" {}

variable "name" {}
variable "network" {}
variable "direction" {}
variable "target_tags" {}
variable "deny_blocks" {
  default = []
}
variable "allow_blocks" {
  default = []
}
