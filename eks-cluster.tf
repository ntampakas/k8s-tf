module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
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

  vpc_id = module.vpc.vpc_id
  #subnet_ids = ["subnet-0dc57a4c01b20efa3", "subnet-0f5b0670ca7ea0451", "subnet-0e9162162c520003e", "subnet-03d14ad2efb4ba5a9", "subnet-04a1fb19f37a5d954", "subnet-0669b83348594305f"]
  subnet_ids = data.aws_subnets.available.ids

  #  self_managed_node_groups = {
  #    one = {
  #      name         = "mixed-1"
  #      max_size     = 5
  #      desired_size = 2
  #
  #      use_mixed_instances_policy = true
  #      mixed_instances_policy = {
  #        instances_distribution = {
  #          on_demand_base_capacity                  = 0
  #          on_demand_percentage_above_base_capacity = 10
  #          spot_allocation_strategy                 = "capacity-optimized"
  #        }
  #
  #        override = [
  #          {
  #            instance_type     = "t3.small"
  #            weighted_capacity = "1"
  #          },
  #          {
  #            instance_type     = "t3.large"
  #            weighted_capacity = "2"
  #          },
  #        ]
  #      }
  #    }
  #  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {

    disk_size              = 50
    instance_types         = ["t3.micro", "t3.small"]
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
    green = {
      #subnet_ids   = [module.vpc.private_subnets]
      subnet_ids   = ["subnet-03a50b200260e2da9", "subnet-086379f5d516a42fd", "subnet-02151b914db27ec16"]
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
    white = {
      subnet_ids   = data.aws_subnets.private.ids
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.micro"]
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
