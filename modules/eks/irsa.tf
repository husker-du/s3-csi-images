module "iam_s3_rw_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["irsa", "s3-csi", "read-write"]
}

resource "aws_iam_role" "s3_rw_role" {
  name = module.iam_s3_rw_context.id

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "${module.eks.oidc_provider_arn}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:${var.s3_csi_namespace}:${var.s3_csi_service_account}",
            "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_rw_policy" {
  name = module.iam_s3_rw_context.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "MountpointAllowReadWriteObjects",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:DeleteObject"
        ],
        Resource = "${var.s3_csi_bucket_arn}/*"
      },
      {
        Sid    = "MountpointAllowListBucket",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = "${var.s3_csi_bucket_arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_rw_policy" {
  role       = aws_iam_role.s3_rw_role.name
  policy_arn = aws_iam_policy.s3_rw_policy.arn
}
