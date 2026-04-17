kubectl version
eksctl version
aws --version

# Create Cluster
eksctl create cluster --name demo-cluster --region ap-south-1 --fargate
eksctl delete cluster --name demo-cluster --region ap-south-1

# Change Config 
aws eks update-kubeconfig --region ap-south-1 --name demo-cluster

# Fargate profile to create app in this namespace as well
eksctl create fargateprofile --cluster demo-cluster --region us-east-1 --name alb-sample-app --namespace game-2048

# Apply manifests
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml

# This aws connector needs to talk with aws resources 
# need OIDC connector
eksctl utils associate-iam-oidc-provider --cluster demo-cluster --approve

# ALB Controller is a pod - If it needs to talk with AWS Services, it needs a role
# Download AWS IAM Policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json

# Creating IAM Policy
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# Create IAM Role
eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve


# Deploy ALB controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

# Install Helm Chart
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<your-region> \
  --set vpcId=<your-vpc-id>
