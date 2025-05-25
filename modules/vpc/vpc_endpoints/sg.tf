#################################################
# VPC endpoint security group
#################################################
resource "aws_security_group" "vpce" {
  name_prefix = module.vpce_context.id
  description = "Associated to Interface VPC Endpoints"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  count             = length(var.private_subnets_ids)
  description       = "Allow Nodes to pull images from ECR via VPC endpoints"
  security_group_id = aws_security_group.vpce.id
  #referenced_security_group_id = 
  cidr_ipv4   = var.private_subnets_cidr_blocks[count.index]
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.vpce.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
