#!/bin/bash

set -euo pipefail

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m"

AWS_PROFILE="quyennv-vti-0405-devops"
AWS_REGION="ap-southeast-1"
EKS_CLUSTER_NAME="qnveks"
USERS_LIST=$(aws --profile $AWS_PROFILE iam list-users --query "Users[*].{Username:UserName, ARN:Arn}" --output text)

echo -e "${CYAN}Load aws member into eks cluster"

POLICY_ARN="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

while read -r arn username; do
    echo "${GREEN}Grant for: ${username}, arn:  ${arn}"

    aws eks create-access-entry \
    --cluster-name "$EKS_CLUSTER_NAME" \
    --principal-arn "$arn" \
    --type STANDARD \
    --user "$username" \
    --kubernetes-groups Viewers \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --no-cli-pager || true

    aws eks associate-access-policy \
    --cluster-name "$EKS_CLUSTER_NAME" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION" \
    --principal-arn "$arn" \
    --access-scope type=cluster \
    --policy-arn "$POLICY_ARN" \
    --no-cli-pager || true

done <<< "$USERS_LIST"