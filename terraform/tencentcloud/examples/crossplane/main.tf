module "cvm" {
    source = "../../module/cvm"
    password = var.password
}

module "k3s" {
    source = "../../module/k3s"
    private_ip = module.cvm.private_ip
    public_ip = module.cvm.public_ip
    password = module.cvm.ssh_password
}

module "helm" {
    source = "../../module/helm"
    filename=module.k3s.kube_config
    helm_charts =var.charts
}