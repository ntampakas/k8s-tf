module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = data.aws_subnets.available.ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {

    disk_size              = 50
    instance_types         = ["t3a.small", "t3.small"]
    create_launch_template = false
    launch_template_name   = ""

    labels = {
      Environment = "test"
      GithubRepo  = "terraform-aws-eks"
      GithubOrg   = "terraform-aws-modules"
      Snip        = "Snap"
    }

    tags = {
      Environment                                       = "test"
      Terraform                                         = "true"
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"               = "true"
    }

  }

  eks_managed_node_groups = {

    blue = {}

    green_private = {
      subnet_ids   = data.aws_subnets.private.ids
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.small"]
      #capacity_type  = "SPOT"
      capacity_type = "ON_DEMAND"

      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Snip        = "Snap"
      }

      tags = {
        Environment = "test"
        Terraform   = "true"
      }
    }

    white_private = {
      subnet_ids   = data.aws_subnets.private.ids
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3a.small"]
      #capacity_type  = "SPOT"
      capacity_type = "ON_DEMAND"

      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Snip        = "Snap"
      }

      tags = {
        Environment = "test"
        Terraform   = "true"
      }
    }

    purple_private = {
      subnet_ids   = data.aws_subnets.private.ids
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Snip        = "Snap"
        prover      = "true"
      }

      tags = {
        Environment = "test"
        Terraform   = "true"
      }
    }

    white_public = {
      subnet_ids   = data.aws_subnets.public.ids
      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = ["t3a.small"]
      #capacity_type  = "SPOT"
      capacity_type = "ON_DEMAND"

      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        Snip        = "Snap"
      }

      tags = {
        Environment = "test"
        Terraform   = "true"
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:kubernetes.io/type"
    values = ["private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:kubernetes.io/type"
    values = ["public"]
  }
}
