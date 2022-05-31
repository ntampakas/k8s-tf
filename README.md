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
   - Before installing Autoscaler/EFS CSI  make sure you set k8s environment and update-kubeconfig:
     ```
     export KUBE_CONFIG_PATH=~/.kube/config
     aws eks --region eu-central-1 update-kubeconfig --name 'nt-eks-test-eks-bCWNg7wR'
     ```
   - VPC name and VPC CIDR can be set editing: __variables.tf_
