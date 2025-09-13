provider "aws" {
  region = "us-east-1"
}

########################################
# VPC
########################################
resource "aws_vpc" "Utc_vpc_vpc" {
  cidr_block           = "172.120.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name       = "Utc-vpc"
    env        = "Dev"
    app-name   = "utc"
    Team       = "wdp"
    created_by = "toscar"
  }
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Utc_vpc_vpc.id

  tags = {
    Name = "Utc-igw"
  }
}

########################################
# Public Subnets
########################################
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.Utc_vpc_vpc.id
  cidr_block              = "172.120.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Utc_public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.Utc_vpc_vpc.id
  cidr_block              = "172.120.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Utc_public-subnet-2"
  }
}

########################################
# Private Subnets
########################################
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.Utc_vpc_vpc.id
  cidr_block        = "172.120.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Utc_private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.Utc_vpc_vpc.id
  cidr_block        = "172.120.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Utc_private-subnet-2"
  }
}

########################################
# Elastic IP for NAT
########################################
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "Utc-eip"
  }
}

########################################
# NAT Gateway (in Public Subnet 1)
########################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "Utc-nat-gw"
  }
}

########################################
# Public Route Table
########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Utc_vpc_vpc.id

  tags = {
    Name = "Utc-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta_public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rta_public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

########################################
# Private Route Table
########################################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.Utc_vpc_vpc.id

  tags = {
    Name = "Utc-private-rt"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "rta_private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "rta_private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
