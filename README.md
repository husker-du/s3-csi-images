# s3-csi-images
Repository with the terraform configuration for creating an Amazon EKS cluster and deploy a service that can fetch and display an image stored in an S3 (Simple Storage Service) bucket using the mountpoint-s3-csi-driver.

## Architecture
![Architecture Diagram](docs/aws-diagram.svg "Architecture Diagram")

## 🔧 Prerequisites

- **terraform** v1.11+
- **terragrunt** v0.77+
- **aws-cli** configured with proper credentials
- **helm** 3 and **kubectl** (for EKS operations)

## 🗂️ Directory structure
`modules/`: Contains reusable Terraform modules for infrastructure components.
This repository contains Terraform modules managed by Terragrunt to provision AWS infrastructure:
- [vpc](modules/vpc/README.md) - networking foundation
- [s3](modules/s3/README.md) - simple object storage for the image server
- [eks](modules/eks/README.md) - managed kubernetes cluster where to deploy the image server

`live/`: Contains environment-specific infrastructure definitions using Terragrunt, here focused on the dev environment in eu-west-1.

`helm/`: Contains the definition of the helm chart templates and helm chart values deployed in the kubernetes cluster.

## ⚙️ Usage

### 🚀 Deploy the dev environment
```bash
# Show what changes will terraform make
terragrunt run-all plan -working-dir=live/dev

# Deploy all infrastructure in dev environment
terragrunt run-all apply -working-dir=live/dev
```

### 💥 Destroy infrastructure
```bash
# Destroy all (be careful!)
terragrunt run-all destroy -working-dir=live/dev
```

### Connect to the kubernetes cluster 
```bash
aws eks update-kubeconfig --region eu-west-1 --name demo-dev-karpenter
```

### Configure the DNS resolution
- Get the name of the AWS load balancer that allows ingress traffic to the kubernetes services.
```bash
kubectl get svc -n nginx-ingress nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}' 
```

- Get the public IPs that 
```bash
nslookup $(kubectl get svc -n nginx-ingress nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}')
```

- Add the IPs from the previous command to the /etc/hosts file to resolve the `app.images.com` name:
```bash
xxx.xxx.xxx.xxx   app.images.com
yyy.yyy.yyy.yyy   app.images.com
zzz.zzz.zzz.zzz   app.images.com
```

- We can request the images via the url:
```bash
http://app.images.com/images/
```