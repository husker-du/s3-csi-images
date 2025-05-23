variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "versioning_enabled" {
  description = "Enable bucket versioning"
  type        = bool
  default     = false
}

variable "acl" {
  description = "Enable bucket versioning"
  type        = string
  default     = "private"
}

##############################################################
# Module S3 VPC endpoint
##############################################################
variable "enable_s3_vpce" {
  description = "Enable a gateway endpoint to access the S3 bucket"
  type        = bool
  default     = false
}

#############################################################
# Dependency variables from VPC module
#############################################################
variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_rtb_ids" {
  description = "The ID of the route table associated to private subnets"
  type        = list(string)
}