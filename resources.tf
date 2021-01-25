provider "aws" {
  region = var.region
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile = "vbawsdemo"
  
}

resource "aws_key_pair" "default" {
    key_name = "${var.user}-tf-key"
    public_key = file(var.key_path)
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ub1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  key_name = aws_key_pair.default.key_name
  tags = {
    Name = "${var.user}-ub1"
  }
}

resource "aws_instance" "ub2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  key_name = aws_key_pair.default.key_name
  tags = {
    Name = "${var.user}-ub2"
  }
}

resource "aws_instance" "ub3" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  key_name = aws_key_pair.default.key_name
  tags = {
    Name = "${var.user}-ub3"
  }
}

resource "aws_cloudformation_stack" "vbaws" {
    name = "${var.user}-vbaws"

    template_url = var.vbawstemplateurl

    parameters = {
        CreateEIP = false
        HTTPLocation = "0.0.0.0/0"
        InstanceType = "t3.medium"
        KeyName = aws_key_pair.default.key_name
        VcbVpcId = aws_vpc.vpc.id
        VcbSubnetId = aws_subnet.public.id
    }

    capabilities = [ "CAPABILITY_IAM"]

    tags = {
        Name = "${var.user}-vbaws"
    }
}