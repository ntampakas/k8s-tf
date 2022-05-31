# k8s-tf
## This terraform code automates EKS creation with some private + public node groups in a new VPC.

## Prerequisites
   - aws account
   - aws cli
   - kubectl
   - helm

## K8s Functions supported:
   - Cluster Autoscaler
   - EFS CSI Driver (shared storage)

## Hints:
   - It` s recommended to provision first the VPC + security groups.
     ```
     root@lptp:/home/lptp/repos/k8s-tf# ls
     README.md  _variables.tf  eks  security-groups.tf  terraform.tfstate  terraform.tfstate.backup  vpc.tf
     root@lptp:/home/lptp/repos/k8s-tf# cat _variables.tf 
     locals {
       vpc = {
         name        = "nt-eks"
         cidr_prefix = "10.45"
       }
     }
     root@lptp:/home/lptp/repos/k8s-tf# terraform init
     root@lptp:/home/lptp/repos/k8s-tf# terraform apply
     root@lptp:/home/lptp/repos/k8s-tf# cp eks/* .
     root@lptp:/home/lptp/repos/k8s-tf# ls
     README.md  _variables.tf  autoscaler.tf  efs-csi.tf  efs.tf  eks  eks-cluster.tf  security-groups.tf  terraform.tfstate  terraform.tfstate.backup    vpc.tf
     root@lptp:/home/lptp/repos/k8s-tf# terraform init
     root@lptp:/home/lptp/repos/k8s-tf# terraform apply
     ```
   - Before installing Autoscaler/EFS CSI  make sure you set k8s environment and update-kubeconfig:
     ```
     export KUBE_CONFIG_PATH=~/.kube/config
     aws eks --region eu-central-1 update-kubeconfig --name 'nt-eks-xxxx'
     ```
   - VPC name and VPC CIDR can be set editing: __variables.tf_
