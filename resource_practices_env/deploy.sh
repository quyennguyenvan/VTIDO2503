#!/bin/bash

set -euo pipefail

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

echo -e "${CYAN}Please provide a Terraform workspace name:${NC}"
read -r tfwf

if [[ -z "$tfwf" ]]; then
    echo -e "${RED}Error: Workspace name cannot be empty.${NC}"
    exit 1
fi

if terraform workspace list | grep -q "$tfwf"; then
    echo -e "${CYAN}Workspace '$tfwf' already exists. Selecting it...${NC}"
else
    echo -e "${CYAN}Creating new workspace '$tfwf'...${NC}"
    terraform workspace new "$tfwf"
fi

terraform workspace select "$tfwf"

current_tfwsp=$(terraform workspace show)
echo -e "${GREEN}Current workspace: ${current_tfwsp}${NC}"

echo -e "${CYAN}Initializing Terraform with backend config...${NC}"
terraform init -backend-config=dev.conf

tfvars_file="envs/${current_tfwsp}.tfvars"
if [[ ! -f "$tfvars_file" ]]; then
    echo -e "${RED}Error: Variable file '$tfvars_file' does not exist.${NC}"
    exit 1
fi

echo -e "${CYAN}Running terraform plan with '${tfvars_file}'...${NC}"
terraform plan -var-file="$tfvars_file"

echo -e "${CYAN}Do you want to apply the infrastructure? Type 'yes' to proceed:${NC}"
read -r tfapply

if [[ "$tfapply" == "yes" ]]; then
    echo -e "${GREEN}Applying infrastructure...${NC}"
    terraform apply -var-file="$tfvars_file"
    echo -e "${GREEN}Apply completed. Please verify the output above.${NC}"
else
    echo -e "${RED}Terraform apply has been cancelled by user.${NC}"
fi