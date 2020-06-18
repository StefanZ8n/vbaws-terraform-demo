# Veeam Backup for AWS Demo
These Terraform scripts provide a demo environment to test Veeam Backup for AWS.

## Disclaimer
This is not an offically Veeam supported script. This is community driven without support.

## What will be created?

- A VPC (the default limit per AWS account and region is 5 but can be increased by creating a support ticket) with a private S3 service endpoint
- Two subnets in the VPC (private and public one)
- Three ubuntu VM (private VPC) to do backups for (`t2.micro`)
- CloudFormation deployment Veeam Backup for AWS (`t2.medium`) in the public VPC (get's a public IP address for access)

## Requirements
- [Terraform](https://www.terraform.io/)
- AWS credentials in `~/.aws/credentials`

        [vbawsdemo]
        aws_access_key_id = ACCESS_KEY
        aws_secret_access_key = SECRET_KEY        

- AWS Credentials must have admin permissions on account
- SSH Keys (Default uses public key from `~/.ssh/id_rsa.pub`)
- An S3 bucket to store backups (best in the same region as your demo environment is deployed to avoid transfer cost)

## Usage

1. Run `terraform init` to get all necessary plugins cached locally
2. Run `terraform plan` to see what will happen.
3. Run `terraform apply` to roll out the config to AWS
4. Use Veeam Backup for AWS (get DNS domain from AWS console)
4. Run `terraform destroy` to delete everything

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

| Name               | Type     | Default value       | Description                                     |
|--------------------|----------|---------------------|-------------------------------------------------|
| `user`             | `string` | `UNKNOWN`           | User name abbreviation for naming resources     |
| `vbawstemplateurl` | `string` | An S3 template URL  | Template URL to the Veeam Backup for AWS        |
| `key_path`         | `string` | `~/.ssh/id_rsa.pub` | The path to your SSH key-pair's public key file |
| `region`           | `string` | `eu-west-1`         | The AWS region to deploy the ressources in      |

