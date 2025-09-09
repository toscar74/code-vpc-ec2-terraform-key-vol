provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "Utc-vpc-vpc" {
    cidr_block = "172.120.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenant = default
    tags = {
        Name = "Utc-vpc"
        env = "Dev"
        app-name = "utc"
        Team = "wdp"
        created_by = "toscar"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc_Utc.id
    tags = {
        Name = "Utc-igw"
    }
}

resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc_Utc.id
    cidr_block              = "10.120.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "Utc_public-subnet-1"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id                  = aws_vpc_Utc.id
    cidr_block              = "10.120.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"
    tags = {
        Name = "Utc_public-subnet-2"
    }
}

resource "aws_subnet" "private_1" {
    vpc_id            = aws_vpc_Utc.id
    cidr_block        = "10.120.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "Utc_private-subnet-1"
    }
}

resource "aws_subnet" "private_2" {
    vpc_id            = aws_vpc_Utc.id
    cidr_block        = "10.120.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "Utc_private-subnet-2"
    }
}
resource "aws_eip" "eip" {

}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id     = aws_subnet.public_1.id
    tags = {
        Name = "Utc-nat-gw"
    }
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc_Utc.id
    tags = {
        Name = "Utc-private-rt"
    }


    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc_Utc.id
    tags = {
        Name = "Utc-public-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_security_group" "web_sg" {
    name        = "web-sg"
    description = "Allow ports 80, 22, 8080"
    vpc_id      = aws_vpc_Utc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-sg"
    }
}