terraform {
  backend "s3" {
    region  = "eu-central-1"
    profile = "devops"
    bucket  = "privacyscaling-tf-state"
    key     = "nt-eks-v2.tfstate"
    encrypt = "true"
  }
}

variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

locals {
  vpc = {
    name        = "nt-eks-v2"
    cidr_prefix = "10.75"
  }
}
