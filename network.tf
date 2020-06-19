data "aws_availability_zones" "available" {
    state = "available"
}
resource "aws_vpc" "vpc" {
    cidr_block = "10.42.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.user}-vpc"
    }
}

data "aws_vpc_endpoint_service" "s3" {
    service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
    vpc_id = aws_vpc.vpc.id
    service_name = data.aws_vpc_endpoint_service.s3.service_name
}

resource "aws_subnet" "public" {
    availability_zone = data.aws_availability_zones.available.names[0]
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.42.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.user}-public"
    }
}

resource "aws_subnet" "private" {
    availability_zone = data.aws_availability_zones.available.names[0]
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.42.2.0/24"
    tags = {
        Name = "${var.user}-private"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.user}-gw"
    }
}

resource "aws_route_table" "routes" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "${var.user}-vbaws"
    }
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
    route_table_id = aws_route_table.routes.id
}

resource "aws_route_table_association" "public-internet" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.routes.id
}

resource "aws_security_group" "public" {
    name = "${var.user}-sg-public"
    description = "Allow incoming HTTPS, SSH and REST-API"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 11005
        to_port = 11005
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all egress"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.user}-sg-public"
    }

}