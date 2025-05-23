resource "helm_release" "nginx_ingress" {
  name             = var.ingress_release_name
  repository       = var.ingress_repository
  chart            = var.ingress_chart
  version          = var.ingress_version
  namespace        = var.ingress_namespace
  create_namespace = true
  wait             = var.ingress_wait

  values = [file("${var.helm_values_path}/nginx-ingress/values.yaml")]
}
