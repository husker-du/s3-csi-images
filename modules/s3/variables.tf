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

#############################################################
# Dependency variables from VPC module
#############################################################
variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_route_table_ids" {
  description = "The ID of the route table associated to private subnets"
  type        = list(string)
}

variable "vpce_s3_id" {
  description = "The ID of the gateway vpc endpoint for S3 service"
  type        = string
}
