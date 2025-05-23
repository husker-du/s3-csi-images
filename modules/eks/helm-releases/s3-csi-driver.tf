resource "helm_release" "s3_csi_driver" {
  name             = var.s3_csi_release_name
  repository       = var.s3_csi_repository
  chart            = var.s3_csi_chart
  version          = var.s3_csi_version
  namespace        = var.s3_csi_namespace
  create_namespace = true
  wait             = true

  values = [templatefile("${var.helm_values_path}/s3-csi-driver/values.yaml.tftpl", {
    csi_driver_role_arn = var.csi_driver_role_arn
  })]
}
