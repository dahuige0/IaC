variable "password" {
  default = "password123"
}

variable "charts" {
  default = [
    {
      name             = "crossplane"
      repository       = "https://charts.crossplane.io/stable"
      chart            = "crossplane"
      namespace        = "crossplane-system"
      create_namespace = true
    },
  ]
}