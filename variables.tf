variable "user"  {
    type = string
    description = "User abbreviation (will be used for all resource-names)"
    default = "UNKNOWN"
}

variable "vbawstemplateurl" {
    type = string
    description = "URL to Veeam Backup for AWS Template"
    default = "https://awsmp-fulfillment-cf-templates-prod.s3-external-1.amazonaws.com/1c943901-fa76-4b45-a69d-f2e64a121e83.e5f07752-44bc-4b98-3ab9-2d47696d2d14.template"
}

variable "key_path" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "region" {
    type = string
    default = "eu-west-1"
}