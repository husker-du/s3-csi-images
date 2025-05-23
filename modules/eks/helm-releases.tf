module "helm_releases" {
  source = "./helm-releases"

  context = module.this.context

  # Helm paths
  helm_charts_path = var.helm_charts_path
  helm_values_path = var.helm_values_path

  # Ingress Nginx controller
  ingress_release_name = var.ingress_release_name
  ingress_namespace    = var.ingress_namespace
  ingress_repository   = var.ingress_repository
  ingress_chart        = var.ingress_chart
  ingress_version      = var.ingress_version
  ingress_wait         = var.ingress_wait

  # Mountpoint S3 CSI driver
  s3_csi_release_name = var.s3_csi_release_name
  s3_csi_namespace    = var.s3_csi_namespace
  s3_csi_repository   = var.s3_csi_repository
  s3_csi_chart        = var.s3_csi_chart
  s3_csi_version      = var.s3_csi_version
  s3_csi_wait         = var.s3_csi_wait
  csi_driver_role_arn = aws_iam_role.s3_rw_role.arn

  # S3 CSI images application
  s3_csi_images_release_name = var.s3_csi_images_release_name
  s3_csi_images_namespace    = var.s3_csi_images_namespace
  s3_csi_images_repository   = var.s3_csi_images_repository
  s3_csi_images_chart        = var.s3_csi_images_chart
  s3_csi_images_version      = var.s3_csi_images_version
  s3_csi_images_wait         = var.s3_csi_images_wait
  s3_csi_bucket_id           = var.s3_csi_bucket_id

  depends_on = [
    module.eks
  ]
}