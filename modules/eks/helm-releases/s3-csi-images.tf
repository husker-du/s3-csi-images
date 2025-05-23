resource "helm_release" "s3_csi_images" {
  name = var.s3_csi_images_release_name
  chart            = var.s3_csi_images_chart
  version          = var.s3_csi_images_version
  namespace        = var.s3_csi_images_namespace
  create_namespace = true
  wait             = true

  values = [templatefile("${var.helm_values_path}/s3-csi-images/values.yaml.tftpl", {
    bucket_id = var.s3_csi_bucket_id
  })]

  depends_on = [
    helm_release.s3_csi_driver,
    helm_release.nginx_ingress
  ]
}
