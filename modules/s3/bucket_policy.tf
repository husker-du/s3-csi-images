#######################################################
# Bucket policy
#######################################################
resource "aws_s3_bucket_policy" "access_from_vpce" {
  count = var.vpce_s3_id != null ? 1 : 0

  bucket = module.s3_csi_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.access_from_vpce.json
}

data "aws_iam_policy_document" "access_from_vpce" {
  statement {
    sid = "AllowVpcEndpointAccess"

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "${module.s3_csi_bucket.s3_bucket_arn}",
      "${module.s3_csi_bucket.s3_bucket_arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = [var.vpce_s3_id]
    }
  }
}
