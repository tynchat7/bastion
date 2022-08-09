# Bastion host deployment

This page contains how to deploy bastion host to FuchiCorp account. If you follow each steps you should be able to deploy successfully.

## Before you begin 
1. Make sure you have gihub token 
2. Make sure that dns zone exist on GCP
3. Also will need `google-credentials.json` file generated in your HOME directory to be able to deploy
4. Make sure you build packer sciprt for bastion host instance [PACKER BUILD ](https://github.com/fuchicorp/bastion/tree/master/packer-scripts) 
5. Make sure you have `~/.kube/config` and have access to cluster


## Deployment 
Fist you will need to clone the repository 
```
git clone https://github.com/fuchicorp/bastion.git
```

## Generate tfvars 
Please name the .tfvars file "fuchicorp-bastion.tfvars". Please fill out the information below with your project information.
```
google_bucket_name          = "BUCKET_NAME"
google_project_id           = "PROJECT_ID"
google_domain_name          = "DOMAIN_NAME"
git_common_token            = "Github token from academy ORG"
deployment_environment      = "tools"
deployment_name             = "bastion"
gce_ssh_user                = "GITHUB-USERNAME"
allow_stopping_for_update   = "true"
machine_type                = "n1-standard-2"
ami_id                      = "packer-AMI"

```

After you have generated tfvars you will need to set environments variables
```
source set-env.sh fuchicorp-bastion.tfvars
```
After you have set environment variables you should be able to deploy to GCP 

```
terraform apply -var-file=$DATAFILE
```
