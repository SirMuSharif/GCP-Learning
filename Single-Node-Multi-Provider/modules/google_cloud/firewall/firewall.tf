// Create a firewall for whatever traffic is specified.
resource "google_compute_firewall" "rules" {
  // Google Project to create the resources in
  project = var.google_project_id

  name = var.name
  network = var.network
  direction = upper(var.direction)
  target_tags = var.target_tags

  // If allow resources are defined, create them here.
  dynamic "allow" {
    for_each = var.allow_blocks
    content {
      protocol  = lower(lookup(allow.value, "protocol"))
      ports     = try(lookup(allow.value, "ports") == "" ? null : lookup(allow.value, "ports"), [])
    }
  }

  // If deny resources are defined, create them here.
  dynamic "deny" {
    for_each = var.deny_blocks
    content {
      protocol  = lower(lookup(deny.value, "protocol"))
      ports     = try(lookup(deny.value, "ports") == "" ? null : lookup(deny.value, "ports"), [])
    }
  }

}
