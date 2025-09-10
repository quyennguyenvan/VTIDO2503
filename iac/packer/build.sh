packer init .
packer validate .
packer build .

#clean up the resources
rm -rf manifest.json
#extract the image build id / image ami id

AMI_ID=$(jq -r '.builds[0].artifact_id' manifest.json | cut -d: -f2)
export AMI_ID
echo "build completed with build AMI_ID: $AMI_ID"