##############################################################
# Null label contexts
##############################################################
module "karpenter_context" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = ["karpenter"]
}

################################################################################
# Karpenter
################################################################################
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.34"

  cluster_name          = module.eks.cluster_name
  enable_v1_permissions = true
  namespace             = var.karpenter_namespace

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = module.eks.cluster_name
  create_pod_identity_association = true

  tags = module.eks_context.tags
}

resource "helm_release" "karpenter" {
  name             = var.karpenter_release_name
  namespace        = var.karpenter_namespace
  create_namespace = true
  chart            = var.karpenter_chart
  version          = var.karpenter_version
  repository       = var.karpenter_repository
  wait             = var.karpenter_wait

  values = [
    templatefile("${var.helm_values_path}/karpenter/values.yaml.tftpl", {
      cluster_name     = module.eks.cluster_name
      cluster_endpoint = module.eks.cluster_endpoint
      queue_name       = module.karpenter.queue_name
    })
  ]
}

################################################################################
# NodePool and EC2NodeClass
################################################################################
resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = templatefile("${path.module}/k8s/karpenter/nodepool.yaml.tftpl", {
    ec2nodeclass_name = kubectl_manifest.karpenter_node_class.name
  })
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = templatefile("${path.module}/k8s/karpenter/nodeclass.yaml.tftpl", {
    cluster_name = module.eks.cluster_name
  })

  depends_on = [
    helm_release.karpenter
  ]
}

################################################################################
# Additional security group for karpenter nodes
################################################################################
resource "aws_security_group" "allow_http_from_core_nodes" {
  name        = module.karpenter_context.id
  description = "Allow HTTP inbound traffic and all outbound traffic from EKS system nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    module.eks_context.tags,
    { "karpenter.sh/discovery" = var.cluster_name }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_core_nodes" {
  security_group_id            = aws_security_group.allow_http_from_core_nodes.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.eks.node_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "allow_http_from_core_nodes" {
  security_group_id            = aws_security_group.allow_http_from_core_nodes.id
  ip_protocol                  = "-1"
  referenced_security_group_id = module.eks.node_security_group_id
}
