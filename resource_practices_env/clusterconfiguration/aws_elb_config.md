follow from: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

**pre-setup**

1. curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json
2. aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
3. eksctl create iamserviceaccount \
    --cluster=qnveks \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::616293267995:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region ap-southeast-1 \
    --profile quyennv-vti-0305-devops \
    --approve 

**aws elb setup**

1. helm repo add eks https://aws.github.io/eks-charts
2. helm repo update eks
3. helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=qnveks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-southeast-1 \
  --set vpcId=vpc-014843c4d758d3a83\
  --version 1.13.0

**verify setup**
1. **kubectl get deployment -n kube-system aws-load-balancer-controller**

**testing resources**
1. kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/examples/2048/2048_full.yaml
2. kubectl apply -f 2048_full.yaml
3. kubectl get ingress/ingress-2048 -n game-2048