#!/bin/bash 

cluster_name=qnveks
aws_region=ap-southeast-1
profile=quyennv-vti-0405-devops
aws_id=164693826317

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json \
    --profile=$profile

eksctl utils associate-iam-oidc-provider --region=$aws_region --cluster=$cluster_name --profile $profile --approve

eksctl create iamserviceaccount \
    --cluster=$cluster_name \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::$aws_id:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region $aws_region \
    --profile $profile \
    --approve 

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$cluster_name \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=$aws_region \
  --set vpcId=vpc-0728d2d2c411d85f4 \
  --version 1.13.0

kubectl get deployment -n kube-system aws-load-balancer-controllers