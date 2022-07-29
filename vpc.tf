data "aws_availability_zones" "available" {}
locals {
  cluster_name = "${local.vpc.name}-dev"
}

module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 1.0.0"

  name                     = local.vpc.name
  tags_prefix              = local.vpc.name
  cidr_block               = "${local.vpc.cidr_prefix}.0.0/16"
  az_count                 = length(data.aws_availability_zones.available.names)
  vpc_enable_dns_hostnames = true

  subnets = {
    public = {
      cidrs = ["${local.vpc.cidr_prefix}.4.0/24", "${local.vpc.cidr_prefix}.5.0/24", "${local.vpc.cidr_prefix}.6.0/24"]
      #nat_gateway_configuration = "all_azs"
      nat_gateway_configuration = "single_az"

      tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
        "kubernetes.io/type"                          = "public"
      }
    }

    private = {
      cidrs        = ["${local.vpc.cidr_prefix}.1.0/24", "${local.vpc.cidr_prefix}.2.0/24", "${local.vpc.cidr_prefix}.3.0/24"]
      route_to_nat = true
      tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"             = "1"
        "kubernetes.io/type"                          = "private"
      }
    }

  }
}
