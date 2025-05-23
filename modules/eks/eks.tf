##############################################################
# Null label contexts
##############################################################
module "eks_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["eks", "cluster"]
}

################################################################################
# EKS cluster
################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.36.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  control_plane_subnet_ids = var.intra_subnet_ids
  subnet_ids               = var.private_subnet_ids

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  cluster_endpoint_public_access           = var.endpoint_public_access
  authentication_mode                      = var.auth_mode
  enable_irsa                              = var.enable_irsa

  cluster_addons = {
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    coredns = {
      configuration_values = jsonencode({
        tolerations = [
          # Allow CoreDNS to run on the same nodes as the Karpenter controller
          # for use during cluster creation when Karpenter nodes do not yet exist
          {
            key    = "CriticalAddonsOnly"
            value  = "true"
            effect = "NoSchedule"
          }
        ]
      })
    }
  }

  eks_managed_node_groups = {
    #  It's recommended to have a Managed Node group for hosting critical add-ons
    #  It's recommended to use Karpenter to place your workloads instead of using Managed Node groups
    #  You can leverage nodeSelector and Taints/tolerations to distribute workloads across Managed Node group or Karpenter nodes.
    core_node_group = {
      name        = var.node_group_config.ami_type
      description = var.node_group_config.description
      ami_type    = var.node_group_config.ami_type

      instance_types = var.node_group_config.instance_types
      capacity_type  = var.node_group_config.capacity_type

      min_size     = var.node_group_config.min_size
      max_size     = var.node_group_config.max_size
      desired_size = var.node_group_config.desired_size

      # Subnet IDs where the nodes/node groups will be provisioned
      subnet_ids = var.private_subnet_ids

      labels = var.node_group_config.labels
      taints = var.node_group_config.taints
    }
  }

  node_security_group_tags = merge(
    module.eks_context.tags, {
      # NOTE - if creating multiple security groups with this module, only tag the
      # security group that Karpenter should utilize with the following tag
      # (i.e. - at most, only one security group should have this tag in your account)
      "karpenter.sh/discovery" = var.cluster_name
    }
  )

  tags = module.eks_context.tags
}


module "disabled_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.36.0"

  create = false
}
