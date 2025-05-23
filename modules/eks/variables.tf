#############################################################
# Mandatory variables
#############################################################
variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of IDs of private subnets"
  type        = list(string)

}

variable "public_subnet_ids" {
  description = "List of IDs of public subnets"
  type        = list(string)
}

variable "intra_subnet_ids" {
  description = "List of IDs of intra subnets"
  type        = list(string)
}

variable "s3_csi_bucket_arn" {
  description = "ARN of the S3 bucket to mount as a filesystem using mountpoint-s3-csi driver"
  type        = string
}

variable "s3_csi_bucket_id" {
  description = "The ID of the S3 bucket to mount as a filesystem using mountpoint-s3-csi driver"
  type        = string
}

#############################################################
# EKS variables
#############################################################
variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "karpenter-demo"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Give the Terraform identity admin access to the cluster which will allow it to deploy resources into the cluster"
  type        = bool
  default     = true
}

variable "node_group_config" {
  description = "Configuration for EKS core node group"
  type = object({
    name           = string
    description    = string
    ami_type       = string
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    max_size       = number
    desired_size   = number
    labels         = map(string)
    taints         = map(any)
  })
  default = {
    name           = "system"
    description    = "System node group"
    ami_type       = "BOTTLEROCKET_x86_64"
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    labels         = {}
    taints         = {}
  }
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "auth_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

#############################################################
# Karpenter variables
#############################################################
variable "karpenter_release_name" {
  description = "The release name of the karpenter helm chart"
  type        = string
  default     = "karpenter"
}

variable "karpenter_namespace" {
  description = "The namespece where to deploy the Karpenter controller"
  type        = string
  default     = "karpenter"
}

variable "karpenter_repository" {
  description = "Repository where to locate the karpenter helm chart"
  type        = string
  default     = "oci://public.ecr.aws/karpenter"
}

variable "karpenter_chart" {
  description = "Name of the karpenter helm chart to be installed"
  type        = string
  default     = "karpenter"
}

variable "karpenter_version" {
  description = "Karpenter's helm chart version"
  type        = string
  default     = "1.3.3"
}

variable "karpenter_wait" {
  description = "Karpenter's helm chart version"
  type        = bool
  default     = false
}

#############################################################
# Helm variables
#############################################################
variable "helm_charts_path" {
  description = "Path of the helm charts"
  type        = string
  default     = "./helm-charts"
}

variable "helm_values_path" {
  description = "Path of the helm chart values"
  type        = string
  default     = "./helm-values"
}

#############################################################
# NGINX ingress controller variables
#############################################################
variable "ingress_release_name" {
  description = "The release name of the nginx controller helm chart"
  type        = string
  default     = "nginx-ingress"
}

variable "ingress_namespace" {
  description = "The namespece where to deploy the nginx ingress controller"
  type        = string
  default     = "nginx-ingress"
}

variable "ingress_repository" {
  description = "Repository where to locate the nginx ingress controller helm chart"
  type        = string
  default     = "oci://ghcr.io/nginx/charts"
}

variable "ingress_chart" {
  description = "Name of the nginx ingress controller helm chart to be installed"
  type        = string
  default     = "nginx-ingress"
}

variable "ingress_version" {
  description = "Nginx ingress controller's helm chart version"
  type        = string
  default     = "2.0.1"
}

variable "ingress_wait" {
  description = "Wait for nginx ingress controller helm chart installation"
  type        = bool
  default     = false
}

#############################################################
# Mountpoint S3 CSI driver
#############################################################
variable "s3_csi_release_name" {
  description = "The release name of the mountpoint s3 csi driver helm chart"
  type        = string
  default     = "s3-csi-driver"
}

variable "s3_csi_namespace" {
  description = "The namespece where to deploy the mountpoint for S3 CSI driver"
  type        = string
  default     = "kube-system"
}

variable "s3_csi_repository" {
  description = "Repository where to locate the mountpoint for S3 CSI driver helm chart"
  type        = string
  default     = "https://awslabs.github.io/mountpoint-s3-csi-driver"
}

variable "s3_csi_chart" {
  description = "Name of the mountpoint for S3 CSI driver helm chart to be installed"
  type        = string
  default     = "aws-mountpoint-s3-csi-driver"
}

variable "s3_csi_version" {
  description = "Version number for mountpoint for S3 CSI driver helm chart"
  type        = string
  default     = "v1.14.1"
}

variable "s3_csi_wait" {
  description = "Wait for mountpoint for S3 CSI driver helm chart installation"
  type        = bool
  default     = false
}


variable "s3_csi_service_account" {
  description = "The service account name of the mountpoint S3 CSI driver"
  type        = string
  default     = "s3-csi-driver-sa"
}

variable "s3_csi_secret_name" {
  description = ""
  type        = string
  default     = "aws-secret"
}

#############################################################
# S3 CSI images application
#############################################################
variable "s3_csi_images_release_name" {
  description = "The release name of the s3-csi-images application"
  type        = string
  default     = "s3-csi-images"
}

variable "s3_csi_images_namespace" {
  description = "The namespece where to deploy the s3-csi-images applicationr"
  type        = string
  default     = "s3-csi-images"
}

variable "s3_csi_images_repository" {
  description = "Repository where to locate the s3-csi-images helm repository"
  type        = string
  default     = "./helm-charts"
}

variable "s3_csi_images_chart" {
  description = "Name of the s3-csi-images helm chart to be installed"
  type        = string
  default     = "s3-csi-images"
}

variable "s3_csi_images_version" {
  description = "Version number for the s3-csi-images helm chart"
  type        = string
  default     = "0.1.0"
}

variable "s3_csi_images_wait" {
  description = "Wait for the s3-csi-images helm release installation"
  type        = bool
  default     = false
}
