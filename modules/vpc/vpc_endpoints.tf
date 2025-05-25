module "vpc_endpoints" {
  count  = var.enable_vpc_endpoints ? 1 : 0
  source = "./vpc_endpoints"

  context                     = module.this.context
  vpc_id                      = module.vpc.vpc_id
  vpc_endpoints               = var.vpc_endpoints
  private_subnets_ids         = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids
}