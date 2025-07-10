#!/bin/bash

set -euo pipefail

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
NC="\033[0m"


echo -e "${CYAN}--- Provide AWS Identity for Access ---${NC}"
read -rp "Enter AWS profile to associate access: " awsprofile
if [[ -z "$awsprofile" ]]; then
    echo -e "${RED}AWS profile cannot be empty.${NC}"
    exit 1
fi

echo -e "${CYAN}--- [1/5] Enter Terraform Workspace ---${NC}"
read -rp "Enter Terraform workspace name: " tfwf
if [[ -z "$tfwf" ]]; then
    echo -e "${RED}Workspace name cannot be empty.${NC}"
    exit 1
fi

if terraform workspace list | grep -q "$tfwf"; then
    echo -e "${CYAN}Workspace exists. Selecting...${NC}"
else
    echo -e "${CYAN}Creating new workspace...${NC}"
    terraform workspace new "$tfwf"
fi
terraform workspace select "$tfwf"
current_tfwsp=$(terraform workspace show)
echo -e "${GREEN}Current workspace: $current_tfwsp${NC}"

echo -e "${CYAN}--- [2/5] Terraform Init & Plan ---${NC}"
if [[ ! -f "envs/${current_tfwsp}.tfvars" ]]; then
    echo -e "${RED}Missing envs/${current_tfwsp}.tfvars${NC}"
    exit 1
fi

terraform init -backend-config=dev.conf
terraform plan -var-file="envs/${current_tfwsp}.tfvars"

read -rp "Do you want to apply the infrastructure? Type 'yes' to continue: " tfapply
if [[ "$tfapply" != "yes" ]]; then
    echo -e "${RED}Cancelled by user.${NC}"
    exit 0
fi

echo -e "${CYAN}--- [3/5] Terraform Apply ---${NC}"
terraform apply -var-file="envs/${current_tfwsp}.tfvars"

echo -e "${CYAN}Waiting for EKS cluster to be ready...${NC}"

# Extract EKS cluster name and region from tf output
eksclustername=$(terraform output -raw eks_cluster_name)
awsregion=$(terraform output -raw aws_region)
# awsregion="ap-southeast-1"

if [[ -z "$eksclustername" || -z "$awsregion" ]]; then
    echo -e "${RED}EKS cluster name or region not found in Terraform output.${NC}"
    exit 1
fi

# Poll cluster status
MAX_RETRIES=20
SLEEP_TIME=15
retry=0
while [[ $retry -lt $MAX_RETRIES ]]; do
    status=$(aws --profile $awsprofile eks describe-cluster --name "$eksclustername" --region "$awsregion" --query "cluster.status" --output text || echo "")
    if [[ "$status" == "ACTIVE" ]]; then
        echo -e "${GREEN}✅ EKS cluster '$eksclustername' is ACTIVE.${NC}"
        break
    fi
    echo -e "${YELLOW}Waiting for EKS cluster to become ACTIVE... (status: $status)${NC}"
    sleep $SLEEP_TIME
    retry=$((retry + 1))
done

if [[ "$status" != "ACTIVE" ]]; then
    echo -e "${RED}❌ EKS cluster did not become ACTIVE in time.${NC}"
    exit 1
fi

echo -e "${CYAN}--- [4/5] Create the EKS access environment ---${NC}"
echo -e "${GREEN}Current aws credential profile: $awsprofile${NC}"

AWS_USER_ARN=$(aws sts get-caller-identity --profile "$awsprofile" | jq -r '.Arn')
AWS_USERNAME=$(echo "$AWS_USER_ARN" | sed 's|.*/||')
POLICY_ARN="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

echo -e "${YELLOW}User Info:${NC}"
echo -e "  User ARN  : ${GREEN}$AWS_USER_ARN${NC}"
echo -e "  Username  : ${GREEN}$AWS_USERNAME${NC}"
echo -e "  Cluster   : ${GREEN}$eksclustername${NC}"
echo -e "  Profile   : ${GREEN}$awsprofile${NC}"
echo -e "  Region    : ${GREEN}$awsregion${NC}"

read -rp "Do you want to associate this user with EKS cluster? (yes to continue): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo -e "${RED}Cancelled by user.${NC}"
    exit 0
fi

echo -e "${CYAN}--- [5/5] Associating Access Entry & Updating Kubeconfig ---${NC}"

aws eks create-access-entry \
    --cluster-name "$eksclustername" \
    --principal-arn "$AWS_USER_ARN" \
    --type STANDARD \
    --user "$AWS_USERNAME" \
    --kubernetes-groups Viewers \
    --profile "$awsprofile" \
    --region "$awsregion" \
    --no-cli-pager

aws eks associate-access-policy \
    --cluster-name "$eksclustername" \
    --profile "$awsprofile" \
    --region "$awsregion" \
    --principal-arn "$AWS_USER_ARN" \
    --access-scope type=cluster \
    --policy-arn "$POLICY_ARN" \
    --no-cli-pager

aws eks update-kubeconfig \
    --region "$awsregion" \
    --profile "$awsprofile" \
    --name "$eksclustername" \
    --no-cli-pager

context=$(kubectl config current-context || echo "N/A")
if echo "$context" | grep -q "$eksclustername"; then
    echo -e "${GREEN}✅ Kubeconfig set for EKS cluster: $context${NC}"
else
    echo -e "${RED}⚠️ Context mismatch. Please check kubeconfig manually.${NC}"
fi

kubectl get namespace -A || echo -e "${RED}Failed to list namespaces. Check kube context or permissions.${NC}"
