# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform and OpenTofu that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/eks.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}

# Configure the version of the module to use in this environment. This allows you to promote new versions one
# environment at a time (e.g., qa -> stage -> prod).
terraform {
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.8.0"
  source = include.envcommon.locals.base_source_url
}

# Dependencies
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "vpc-mock123"
    public_subnet_ids  = ["subnet-public-mock123"]
    private_subnet_ids = ["subnet-private-mock123"]
    intra_subnet_ids   = ["subnet-intra-mock123"]
  }
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    bucket_arn = "arn:aws:s3:::s3_bucket_mock123"
    bucket_id = "s3_bucket_mock123"
  }
}

# For production, we want to specify bigger instance classes and storage, so we specify override parameters here. These
# inputs get merged with the common inputs from the root and the envcommon terragrunt.hcl
inputs = {
  # VPC dependencies
  vpc_id             = dependency.vpc.outputs.vpc_id
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  intra_subnet_ids   = dependency.vpc.outputs.intra_subnet_ids

  # S3 dependencies
  s3_csi_bucket_arn = dependency.s3.outputs.bucket_arn
  s3_csi_bucket_id  = dependency.s3.outputs.bucket_id
}
