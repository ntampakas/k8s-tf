variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "${local.vpc.name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name                 = local.vpc.name
  cidr                 = "${local.vpc.cidr_prefix}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${local.vpc.cidr_prefix}.1.0/24", "${local.vpc.cidr_prefix}.2.0/24", "${local.vpc.cidr_prefix}.3.0/24"]
  public_subnets       = ["${local.vpc.cidr_prefix}.4.0/24", "${local.vpc.cidr_prefix}.5.0/24", "${local.vpc.cidr_prefix}.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/type"                          = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/type"                          = "private"
  }
}
