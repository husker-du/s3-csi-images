output "vpc_endpoint_dns_names" {
  description = "DNS names for the VPC endpoint interfaces"
  value       = { for service, endpoint in aws_vpc_endpoint.interface : service => endpoint.dns_entry[*].dns_name }
}

output "vpce_s3_id" {
  description = "The ID of the gateway vpc endpoint for S3 service"
  value       = aws_vpc_endpoint.gateway["s3"].id
}
