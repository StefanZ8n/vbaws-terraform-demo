variable "user"  {
    type = string
    description = "User abbreviation (will be used for all resource-names)"
    default = "UNKNOWN"
}

variable "vbawstemplateurl" {
    type = string
    description = "URL to Veeam Backup for AWS Template"
    default = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/de89d163-440b-40fb-9b4c-f91fb0e18e29/23dd60c4ec94478e9a2d9996187a3b7a.template"
}

variable "key_path" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "region" {
    type = string
    default = "eu-west-1"
}