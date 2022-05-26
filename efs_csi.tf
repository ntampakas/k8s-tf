module "efs_csi_driver" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-efs-csi-driver.git"

  cluster_name                     = local.cluster_name
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

}

