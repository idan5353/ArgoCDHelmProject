module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.eks_cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # Allow kubectl from your local machine
  cluster_endpoint_public_access = true

  # Enable IRSA (OIDC provider)
  enable_irsa = true

  # Managed node group
  eks_managed_node_groups = {
    default = {
      name           = "${var.project_name}-ng"
      instance_types = var.node_instance_types

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      # Use AL2 — stable and well-supported
      ami_type = "AL2_x86_64"

      labels = {
        Environment = var.environment
      }

      tags = {
        Project     = var.project_name
        Environment = var.environment
      }
    }
  }

  # Enable common EKS addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
