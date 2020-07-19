export AWS_REGION=us-east-1 # This is used to help encode your environment variables
export AWS_ACCESS_KEY_ID=AKIA5CQLQVCU2H3JU6NB
export AWS_SECRET_ACCESS_KEY=MnrppFvIG3h1DazN2toBWXlccIqmI7WAkR9lOHja

# The clusterawsadm utility takes the credentials that you set as environment
# variables and uses them to create a CloudFormation stack in your AWS account
# with the correct IAM resources.
clusterawsadm bootstrap iam create-cloudformation-stack

# Create the base64 encoded credentials using clusterawsadm.
# This command uses your environment variables and encodes
# them in a value to be stored in a Kubernetes Secret.
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)

# Finally, initialize the management cluster
clusterctl init --infrastructure aws

export AWS_REGION=us-east-1
export AWS_SSH_KEY_NAME=default
# Select instance types
export AWS_CONTROL_PLANE_MACHINE_TYPE=t3.large
export AWS_NODE_MACHINE_TYPE=t3.large

aws ec2 create-key-pair --key-name default | jq .KeyMaterial -r

clusterctl config cluster capi-quickstart --kubernetes-version v1.17.3 --control-plane-machine-count=3 --worker-machine-count=3 > capi-quickstart.yaml

curl https://docs.projectcalico.org/v3.15/manifests/calico.yaml > calico.yaml
