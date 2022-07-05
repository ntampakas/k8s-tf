# k8s-tf (non prod version)
## This terraform code automates EKS creation with some private + public node groups in a new VPC.

## Prerequisites
   - aws account
   - aws cli
   - kubectl
   - helm

## K8s Functions supported:
   - Cluster Autoscaler

## Hints:
   - It` s recommended to provision first the VPC + security groups.
     ```
     # ls
     README.md  _variables.tf  eks  security-groups.tf  terraform.tfstate  terraform.tfstate.backup  vpc.tf
     # cat _variables.tf 
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
     # terraform init
     # terraform apply
     # cp eks/* .
     # ls
     README.md  _variables.tf  autoscaler.tf  efs-csi.tf  efs.tf  eks  eks-cluster.tf  security-groups.tf  terraform.tfstate  terraform.tfstate.backup    vpc.tf
     # terraform init
     # terraform apply
     ```
   - Before installing Autoscaler make sure you set k8s environment and update-kubeconfig:
     ```
     # export KUBE_CONFIG_PATH=~/.kube/config
     # aws eks --region eu-central-1 update-kubeconfig --name 'nt-eks-xxxx'
     ```
   - VPC name and VPC CIDR can be set editing: __variables.tf_
   - Edit backend.s3 in __variables.tf_ to determine where state will be stored
