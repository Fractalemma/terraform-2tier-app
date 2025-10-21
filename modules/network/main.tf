# Notes:
# - Internet Gateway attached to the VPC is required for public subnets.
# - 6 Subnets needed:
#   - 2 Public Subnets for NAT Gateways (pub-sub-a, pub-sub-b)
#   - 2 Private Subnets for Web Tier (pri-sub-web-a, pri-sub-web-b)
#   - 2 Private Subnets for Data Tier (pri-sub-data-a, pri-sub-data-b)

# VPC
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support =  true

  tags      = {
    Name    = "${var.module_prefix}-vpc"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc



# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.module_prefix}-igw"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway



# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

#----- Public Subnets
#-- Public Subnet AZ A
resource "aws_subnet" "pub_sub_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.module_prefix}-pub_sub_a"
  }
}
#-- Public Subnet AZ B
resource "aws_subnet" "pub_sub_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.module_prefix}-pub_sub_b"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet



# Route Table for Public Subnets (attach Internet Gateway to VPC)
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "${var.module_prefix}-public-rt"
  }
}
# associate public subnet pub_sub_a to "public route table"
resource "aws_route_table_association" "pub_sub_a_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_a.id
  route_table_id      = aws_route_table.public_route_table.id
}
# associate public subnet pub_sub_b to "public route table"
resource "aws_route_table_association" "pub_sub_b_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_b.id
  route_table_id      = aws_route_table.public_route_table.id
}



#----- Private Subnets
#-- Web tier
# create private app subnet pri-sub-web-a
resource "aws_subnet" "pri_sub_web_a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_web_a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.module_prefix}-pri-sub-web-a"
  }
}
# create private app subnet pri-sub-web-b
resource "aws_subnet" "pri_sub_web_b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_web_b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.module_prefix}-pri-sub-web-b"
  }
}
#-- Data tier
# create private data subnet pri-sub-data-a
resource "aws_subnet" "pri_sub_data_a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_data_a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.module_prefix}-pri-sub-data-a"
  }
}
# create private data subnet pri-sub-data-b
resource "aws_subnet" "pri_sub_data_b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_data_b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.module_prefix}-pri-sub-data-b"
  }
}