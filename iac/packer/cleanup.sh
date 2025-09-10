AWS_PROFILE="quyennvdotcom"
AWS_REGION="ap-southeast-1"
NAME_PREFIX="excersice_packer"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity  --profile $AWS_PROFILE --no-cli-pager | jq -r '.Account' )

echo "Clean up resources\n\
[+] AWS PROFILE = ${AWS_PROFILE} \n\
[+] AWS_REGION = ${AWS_REGION} \n\
[+] AWS_ACCOUNT_ID = ${AWS_ACCOUNT_ID} \n\
[+] RESOURCES PREFIX = ${NAME_PREFIX}"

AMIS=$(aws ec2 describe-images \
  --owners $AWS_ACCOUNT_ID \
  --region $AWS_REGION \
  --filters "Name=name,Values=${NAME_PREFIX}*" \
  --query "Images[*].[ImageId,CreationDate]" \
  --output text --profile $AWS_PROFILE | sort -k2)
  
TO_DELETE=$(echo "$AMIS" | awk '{print $1}')

for ami in $TO_DELETE; do
  echo "Deregistering $ami"
  aws ec2 deregister-image --image-id $ami --profile $PROFILE --region $REGION

  SNAPSHOT_IDS=$(aws ec2 describe-images --image-ids $ami \
    --query "Images[*].BlockDeviceMappings[*].Ebs.SnapshotId" \
    --output text --profile $PROFILE --region $REGION)

  for snap in $SNAPSHOT_IDS; do
    echo "Deleting snapshot $snap"
    aws ec2 delete-snapshot --snapshot-id $snap --profile $PROFILE --region $REGION
  done
done