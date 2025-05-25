variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_subnets_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "private_subnets_cidr_blocks" {
  description = "List of private subnet cidr blocks"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "The ID of the route table associated to private subnets"
  type        = list(string)
}

variable "vpc_endpoints" {
  description = "Map of interface and gateway vpc endpoints to create"
  type = object({
    Gateway   = optional(list(string))
    Interface = optional(list(string))
  })
  default = {
    Gateway   = []
    Interface = []
  }
}
