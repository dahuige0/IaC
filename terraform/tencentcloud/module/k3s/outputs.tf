output "kube_config" {
  description = "kubeconfig"
  value       = "${path.cwd}/config.yaml"
}