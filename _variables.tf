terraform {
  backend "s3" {
    region  = "eu-central-1"
    profile = "devops"
    bucket  = "privacyscaling-tf-state"
    key     = "nt-eks.tfstate"
    encrypt = "true"
  }
}

locals {
  vpc = {
    name        = "nt-eks"
    cidr_prefix = "10.45"
  }
}
