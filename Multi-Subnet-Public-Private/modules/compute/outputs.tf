// Output the Bastion's Public IP
output "bastion" {
  value = local.bastion
}

// Output the K3s Worker Private IP
output "k3s_worker" {
  value = local.k3s_worker
}