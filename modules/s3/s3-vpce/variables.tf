variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_rtb_ids" {
  description = "The ID of the route table associated to private subnets"
  type        = list(string)
}

variable "bucket_arn" {
  description = "The ARN of the bucket to mount"
  type        = string
}

variable "bucket_id" {
  description = "The ARN of the bucket to mount"
  type        = string
}