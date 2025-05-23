##############################################################
# Null label contexts
##############################################################
module "s3_vpce_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["s3", "vpce"]
}

##############################################################
# S3 Gateway Endpoint with full configuration
##############################################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # Route table associations - associate with private route tables
  route_table_ids = var.private_rtb_ids

  # Policy to control access to the S3 endpoint
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.bucket_arn}",
          "${var.bucket_arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = var.vpc_id
          }
        }
      }
    ]
  })

  # Tags
  tags = module.s3_vpce_context.tags
}