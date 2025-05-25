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
  description = "Wait for the nginx ingress controller helm release installation"
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
  description = "Wait for the mountpoint for S3 CSI driver helm release installation"
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

variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-west-1"
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
# Mandatory variables
#############################################################
variable "csi_driver_role_arn" {
  description = "The S3 CSI driver IRSA role arn"
  type        = string
}

variable "s3_csi_bucket_id" {
  description = "The ID of the S3 bucket to mount as a filesystem using mountpoint-s3-csi driver"
  type        = string
}
