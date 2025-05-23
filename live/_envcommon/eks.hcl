# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for vpc. The common variables for each environment to
# deploy vpc are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env = local.env_vars.locals.stage

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the source URL in the child terragrunt configurations.
  base_source_url = "${get_repo_root()}/modules//eks"
}

inputs = {
  region = local.region_vars.locals.aws_region

  # EKS cluster
  cluster_version        = "1.32"
  endpoint_public_access = true
  enable_irsa            = true

  node_group_config = {
    name           = "core-node-group"
    description    = "EKS Core node group for hosting system add-ons"
    ami_type       = "BOTTLEROCKET_x86_64"
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    labels = {
      # Used to ensure Karpenter runs on nodes that it does not manage
      "CriticalAddonsOnly" = "true"
    }
    taints = {
      # The pods that do not tolerate this taint should run on nodes
      # created by Karpenter
      karpenter = {
        key    = "CriticalAddonsOnly"
        value  = "true"
        effect = "NO_SCHEDULE"
      }
    }
  }
  enable_cluster_creator_admin_permissions = true

  # Helm paths
  helm_charts_path = "${get_repo_root()}/helm/charts"
  helm_values_path = "${get_repo_root()}/helm/values"

  # Karpenter
  karpenter_release_name = "karpenter"
  karpenter_version      = "1.3.3"
  karpenter_namespace    = "karpenter"
  karpenter_repository   = "oci://public.ecr.aws/karpenter"
  karpenter_chart        = "karpenter"
  karpenter_wait         = true

  # Nginx ingress controller
  ingress_release_name = "nginx-ingress"
  ingress_namespace    = "nginx-ingress"
  ingress_repository   = "oci://ghcr.io/nginx/charts"
  ingress_chart        = "nginx-ingress"
  ingress_version      = "2.0.1"
  ingress_wait         = true

  # Mountpoint S3 CSI driver
  s3_csi_release_name = "s3-csi-driver"
  s3_csi_version      = "v1.14.1"
  s3_csi_namespace    = "kube-system"
  s3_csi_repository   = "https://awslabs.github.io/mountpoint-s3-csi-driver"
  s3_csi_chart        = "aws-mountpoint-s3-csi-driver"
  s3_csi_wait         = true

  # S3 CSI images application
  s3_csi_images_release_name = "s3-csi-images"
  s3_csi_images_namespace    = "s3-csi-images"
  s3_csi_images_chart        = "${get_repo_root()}/helm/charts/s3-csi-images"
  s3_csi_images_version      = "0.1.1"
  s3_csi_images_wait         = true
}
