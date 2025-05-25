#################################################
# Null label contexts
#################################################
module "vpce_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["vpce"]
}

module "vpce_interface_context" {
  for_each = toset(flatten(values(var.vpc_endpoints)))

  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.vpce_context.context
  attributes = [replace(each.key, ".", "-")]
}

#################################################
# VPC endpoints
#################################################
resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.vpc_endpoints.Interface)
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets_ids
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = module.vpce_interface_context[each.key].tags
}

resource "aws_vpc_endpoint" "gateway" {
  for_each          = toset(var.vpc_endpoints.Gateway)
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  # Route table associations - associate with private route tables
  route_table_ids = var.private_route_table_ids

  # Policy to control access to the S3 endpoint
  policy = each.key == "s3" ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = var.vpc_id
          }
        }
      }
    ]
  }) : null

  tags = module.vpce_interface_context[each.key].tags
}


