output "public_ip" {
  description = "vm public ip address"
  value       = module.cvm.public_ip
}

output "private_ip" {
  description = "vm public ip address"
  value       = module.cvm.private_ip
}

output "ssh_password" {
  description = "The SSH password of instance."
  value       = module.cvm.password
}