output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3_csi_bucket.s3_bucket_arn
}

output "bucket_id" {
  description = "S3 bucket name"
  value       = module.s3_csi_bucket.s3_bucket_id
}
