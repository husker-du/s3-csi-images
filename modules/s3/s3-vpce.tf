##############################################################
# S3 vpc endpoint
##############################################################
module "s3_vpce" {
  count = var.enable_s3_vpce ? 1 : 0

  source = "./s3-vpce"
  
  context         = module.this.context
  region          = var.region
  vpc_id          = var.vpc_id
  private_rtb_ids = var.private_rtb_ids
  bucket_arn      = module.s3_csi_bucket.s3_bucket_arn
  bucket_id       = module.s3_csi_bucket.s3_bucket_id

}
