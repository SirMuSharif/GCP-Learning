// Craft the specific output for calling multiple nested outputs.
locals {
  bastion = {
    // Output the Bastion Public IP Address.
    public_ip = google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip
  }
  k3s_worker = {
    // Output the K3s worker private IP Address.
    private_ip = google_compute_instance.k3s_worker.network_interface.0.network_ip
  }
}