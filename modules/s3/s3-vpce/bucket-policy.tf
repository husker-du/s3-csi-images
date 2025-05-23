#######################################################
# Bucket policy
#######################################################
resource "aws_s3_bucket_policy" "access_from_vpce" {
  bucket = var.bucket_id
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
      "${var.bucket_arn}",
      "${var.bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = [aws_vpc_endpoint.s3.id]
    }
  }
}