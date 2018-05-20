# terraform-vpn-gcptoaws

POC Hybrid Cloud Two Tier App

![Solution Diagram](diagram.jpg)

## Install

[Terraform install files](https://www.terraform.io/downloads.html)

### Prerequisites

Keys are set via secrets.tfvars (AWS) and account.json (GCP)

When working with AWS resources invoke your keys as so: 

```
terraform apply -var-file="secrets.tfvars"

```

## Usage 

cd to required environment (dev or prod)

You can use -target to isolate the infrastructure you wish to build/destroy


```
terraform init

terraform plan [-target="resource.name"] [-var-file="secrets.tfvars"]

terraform apply [-target="resource.name"] [-var-file="secrets.tfvars"]

terraform destroy [-target="resource.name"] [-var-file="secrets.tfvars"]

```

### .gitignore requirements

```
**/*.pem
**/*.ppk
**/*account.json
**/secrets.tfvars
**/terraform.tfstate
**/terraform.tfstate.backup
**/terraform.tfstate.lock.info
**/plugins/*
**/.terraform/*

```

**Ensure you have a .gitignore file populated as above!!!**

### References

[Google guide on VPN to AWS](https://cloud.google.com/solutions/automated-network-deployment-multicloud)
[Example terraform code on Google VPN](https://github.com/GoogleCloudPlatform/autonetdeploy-multicloudvpn)
[Step by step guide on setting up VPN in the consoles](https://jumpcloud.com/engineering-blog/connect-gce-and-aws/)
