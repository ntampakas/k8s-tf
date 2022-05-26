module "efs" {
  source = "git::https://github.com/ntampakas/tf-efs-module.git"

  creation_token   = local.cluster_name
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"
  encrypted        = "true"

  subnets         = data.aws_subnets.private.ids
  security_groups = [data.aws_security_group.selected.id]
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:aws:eks:cluster-name"
    values = [local.cluster_name]
  }
}
