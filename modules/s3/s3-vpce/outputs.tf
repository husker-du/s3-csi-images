output "s3_vpce_arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint."
  value       = aws_vpc_endpoint.s3.arn
}

output "s3_vpce_cidr_blocks" {
  description = "The list of CIDR blocks for the exposed AWS service. Applicable for endpoints of type Gateway."
  value       = aws_vpc_endpoint.s3.cidr_blocks
}

output "s3_vpce_prefix_list" {
  description = "The prefix list ID of the exposed AWS service. Applicable for endpoints of type Gateway."
  value       = aws_vpc_endpoint.s3.prefix_list_id
}

output "s3_vpce_state" {
  description = "The state of the VPC endpoint."
  value       = aws_vpc_endpoint.s3.state
}