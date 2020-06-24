# Veeam Backup for AWS Demo

These Terraform scripts provide a demo environment to test Veeam Backup for AWS.

## Disclaimer

This is not an offically Veeam supported script. This is community driven
without support.

## What will be created?

- A VPC (the default limit per AWS account and region is 5 but can be increased
  by creating a support ticket) with a private S3 service endpoint
- Two subnets in the VPC (private and public one) within the first availability
  zone
- Three ubuntu VMs 20.04 (private VPC) to have some backup sources (`t3.micro`)
- CloudFormation deployment Veeam Backup for AWS (`v2.0.0` on `t3.medium`) in
  the public VPC (get's a public IP address for access)

## What is NOT included?

- No S3 bucket for backups is created and logically also not removed by this
  terraform script. You have to create the bucket and clean up the data yourself
  when you don't need it anymore.
- Any additionally added EC2 instances won't be cleaned up of course and might
  block the deletion of subnets, VPC, etc... - so clean them up manually when
  required.
- Volume snapshots created by backup policies won't be cleaned up while the
  initially created volumes will be deleted. 

## Requirements

- [Terraform](https://www.terraform.io/)
- AWS credentials in `~/.aws/credentials`

        [vbawsdemo]
        aws_access_key_id = ACCESS_KEY
        aws_secret_access_key = SECRET_KEY

- AWS Credentials must have admin permissions on account
- SSH Keys (Default uses public key from `~/.ssh/id_rsa.pub`)
- An S3 bucket to store backups (best in the same region as your demo
  environment is deployed to avoid transfer cost)

## Usage

1. Run `terraform init` to get all necessary plugins cached locally
2. Run `terraform plan` to see what will happen.
3. Run `terraform apply` to roll out the config to AWS
4. Use Veeam Backup for AWS (get DNS domain from AWS console)
5. Run `terraform destroy` to delete everything

You can also specify values for the following variables to adjust the output.
Specify variables either via CLI

        terraform apply -var="user=sz"

or via environment variable

        export TF_VAR_user=sz   # Linux
        set TF_VAR_user sz      # Windows
        terraform apply

or in a variable file (e.g. `myconfig.auto.tfvars`)

        user = "sz"

### Variables

| Name               | Type     | Default value       | Description                                                          |
| ------------------ | -------- | ------------------- | -------------------------------------------------------------------- |
| `user`             | `string` | `UNKNOWN`           | User name abbreviation for naming resources                          |
| `vbawstemplateurl` | `string` | An S3 template URL  | Cloud Formation Template URL for the Veeam Backup for AWS deployment |
| `key_path`         | `string` | `~/.ssh/id_rsa.pub` | The path to your SSH key-pair's public key file                      |
| `region`           | `string` | `eu-west-1`         | The AWS region to deploy the ressources in                           |
