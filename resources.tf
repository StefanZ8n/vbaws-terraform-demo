provider "aws" {
  region                  = var.region
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile                 = "vbawsdemo"
}

resource "aws_key_pair" "default" {
    key_name = "${var.user}-tf-key"
    public_key = file("${var.key_path}")
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ub1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  tags = {
    Name = "${var.user}-ub1"
  }
}

resource "aws_cloudformation_stack" "vbaws" {
    name = "${var.user}-vbaws"

    template_url = var.vbawstemplateurl

    parameters = {
        CreateEIP = false
        CreateLifecyclePolicy = true
        CreateRebootAlarm = true
        CreateRecoveryAlarm = true
        HTTPLocation = "0.0.0.0/0"
        InstanceType = "t2.medium"
        SSHLocation = "0.0.0.0/0"
        KeyName = aws_key_pair.default.key_name
        VcbVpcId = aws_vpc.vpc.id
        VcbSubnetId = aws_subnet.public.id
    }

    capabilities = [ "CAPABILITY_IAM"]

    tags = {
        Name = "${var.user}-vbaws"
    }
}