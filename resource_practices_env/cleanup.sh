#!/bin/bash
set -euo pipefail

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
NC="\033[0m"

echo -e "${CYAN}--- Cleanup Terraform + EKS Access ---${NC}"

read -rp "Enter AWS profile used to create the access: " awsprofile
if [[ -z "$awsprofile" ]]; then
    echo -e "${RED}AWS profile required.${NC}"
    exit 1
fi

# Ask for Terraform workspace
read -rp "Enter the Terraform workspace to destroy: " tfwf
if [[ -z "$tfwf" ]]; then
    echo -e "${RED}Workspace name required.${NC}"
    exit 1
fi

# Select workspace
if ! terraform workspace list | grep -q "$tfwf"; then
    echo -e "${RED}Workspace '$tfwf' does not exist.${NC}"
    exit 1
fi
terraform workspace select "$tfwf"
current_tfwsp=$(terraform workspace show)

# Confirm variable file exists
tfvars_file="envs/${current_tfwsp}.tfvars"
if [[ ! -f "$tfvars_file" ]]; then
    echo -e "${RED}Variable file '$tfvars_file' not found.${NC}"
    exit 1
fi

echo -e "${YELLOW}Running terraform destroy...${NC}"
terraform destroy -var-file="$tfvars_file"

# Extract outputs
echo -e "${CYAN}Extracting EKS info from Terraform outputs...${NC}"
eksclustername=$(terraform output -raw eks_cluster_name)
awsregion=$(terraform output -raw aws_region)

AWS_USER_ARN=$(aws sts get-caller-identity --profile "$awsprofile" | jq -r '.Arn')
AWS_USERNAME=$(echo "$AWS_USER_ARN" | sed 's|.*/||')
POLICY_ARN="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

# Detach policy
echo -e "${YELLOW}Detaching access policy from cluster...${NC}"
aws eks disassociate-access-policy \
    --cluster-name "$eksclustername" \
    --region "$awsregion" \
    --profile "$awsprofile" \
    --principal-arn "$AWS_USER_ARN" \
    --access-scope type=cluster \
    --no-cli-pager || echo -e "${RED}Warning: Failed to disassociate policy. It might not exist.${NC}"

# Delete access entry
echo -e "${YELLOW}Deleting access entry for user...${NC}"
aws eks delete-access-entry \
    --cluster-name "$eksclustername" \
    --region "$awsregion" \
    --profile "$awsprofile" \
    --principal-arn "$AWS_USER_ARN" \
    --no-cli-pager || echo -e "${RED}Warning: Failed to delete access entry. It might not exist.${NC}"

# Optional: Delete workspace
read -rp "Do you want to delete the Terraform workspace '$tfwf'? (yes to delete): " delwsp
if [[ "$delwsp" == "yes" ]]; then
    terraform workspace select default
    terraform workspace delete "$tfwf"
    echo -e "${GREEN}Workspace '$tfwf' deleted.${NC}"
fi

echo -e "${GREEN}✅ Cleanup complete.${NC}"
