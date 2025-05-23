##############################################################
# Null label contexts
##############################################################
module "s3_csi_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["s3", "csi", "images"]
}

##############################################################
# S3 bucket
##############################################################
module "s3_csi_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.8.0"

  bucket        = module.s3_csi_context.id
  acl           = var.acl
  force_destroy = true

  control_object_ownership = true

  versioning = {
    enabled = var.versioning_enabled
  }
}

module "s3_csi_object" {
  for_each = { for file in local.image_files : file => file }

  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "4.8.0"

  bucket      = module.s3_csi_bucket.s3_bucket_id
  key         = "images/${each.value}"
  file_source = "${path.module}/images/${each.key}"
  etag        = filemd5("${path.module}/images/${each.key}")
}
