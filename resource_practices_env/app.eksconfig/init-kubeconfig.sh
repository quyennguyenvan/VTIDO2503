#!/bin/bash

set -euo pipefail

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m"

echo -e "${CYAN}Step 1: Provide AWS Configuration${NC}"
read -rp "Enter AWS profile: " awsprofile
read -rp "Enter AWS region: " awsregion
read -rp "Enter EKS Cluster name: " eksclustername

# Validate required input
if [[ -z "$awsprofile" || -z "$awsregion" || -z "$eksclustername" ]]; then
    echo -e "${RED}Error: All fields (AWS profile, region, cluster name) are required.${NC}"
    exit 1
fi

# Get current AWS user ARN
echo -e "${CYAN}Fetching AWS user info...${NC}"
if ! AWS_USER_ARN=$(aws sts get-caller-identity --profile "$awsprofile" --output json | jq -r '.Arn'); then
    echo -e "${RED}Failed to get AWS user identity. Check your AWS profile: $awsprofile${NC}"
    exit 1
fi

AWS_USERNAME=$(echo "$AWS_USER_ARN" | sed 's|.*/||')
POLICY_ARN="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

# Show config summary
echo -e "\n${YELLOW}Configuration Summary:${NC}"
echo -e "  AWS User ARN   : ${GREEN}$AWS_USER_ARN${NC}"
echo -e "  AWS Username   : ${GREEN}$AWS_USERNAME${NC}"
echo -e "  Cluster Name   : ${GREEN}$eksclustername${NC}"
echo -e "  AWS Profile    : ${GREEN}$awsprofile${NC}"
echo -e "  AWS Region     : ${GREEN}$awsregion${NC}"
echo ""

read -rp "Do you want to proceed with access configuration? (yes to continue): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo -e "${RED}Cancelled by user.${NC}"
    exit 0
fi

# Create access entry
echo -e "${CYAN}Granting access to EKS cluster...${NC}"
aws eks create-access-entry \
    --cluster-name "$eksclustername" \
    --principal-arn "$AWS_USER_ARN" \
    --type STANDARD \
    --user "$AWS_USERNAME" \
    --kubernetes-groups Viewers \
    --profile "$awsprofile" \
    --region "$awsregion"

# Associate admin policy
aws eks associate-access-policy \
    --cluster-name "$eksclustername" \
    --profile "$awsprofile" \
    --region "$awsregion" \
    --principal-arn "$AWS_USER_ARN" \
    --access-scope type=cluster \
    --policy-arn "$POLICY_ARN"

# Update kubeconfig
echo -e "${CYAN}Updating kubeconfig for cluster access...${NC}"
aws eks update-kubeconfig \
    --region "$awsregion" \
    --profile "$awsprofile" \
    --name "$eksclustername"

# Verification
echo -e "${CYAN}Verifying access to the EKS cluster...${NC}"
current_context=$(kubectl config current-context || echo "N/A")
if echo "$current_context" | grep -q "$eksclustername"; then
    echo -e "${GREEN}✅ Current kube context is set to: $current_context${NC}"
else
    echo -e "${RED}❌ Current context is not pointing to $eksclustername. Please check manually.${NC}"
fi

echo -e "${CYAN}Listing all namespaces...${NC}"
kubectl get namespace -A || echo -e "${RED}Failed to list namespaces. Check kubectl context or permissions.${NC}"