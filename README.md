# k8s-tf
## This terraform code automates EKS creation with some dummy node groups in a new VPC.

## Prerequisites
   - aws account
   - aws cli
   - kubectl

## K8s Functions supported:
   - Cluster Autoscaler

## K8s Functions to be supported:
   - EFS CSI Driver (shared storage)
   - metrics
   - grafana/prometheus


## Hints:
   - It` s recommended to provision first the VPC.
   - Before installing Autoscaler make sure you set k8s environment and update-kubeconfig:
     ```
     export KUBE_CONFIG_PATH=~/.kube/config
     aws eks --region eu-central-1 update-kubeconfig --name 'nt-eks-test-eks-bCWNg7wR'
     ```
   - Currently used 10.45.0.0/16 CIDR. A template network with instructions will be introduced 

