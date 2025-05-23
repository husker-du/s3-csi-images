# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  # Null label naming convention
  stage = "dev"

  # The cluster name is used by the vpc and eks modules
  cluster_name = "demo-cluster"
}
