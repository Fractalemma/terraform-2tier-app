# Notes:
# - NAT Gateway must be created in a public subnet, different from the one where the instances are located.
# - Each NAT Gateway requires an Elastic IP.
# - Requires an Internet Gateway attached to the VPC.
# - The goal is to provide internet access to EC2 and RDS instances in private subnets



# Elastic IP for the nat-gateway in the public subnet pub-sub-1-a
resource "aws_eip" "eip-nat-a" {
  domain = "vpc"
  tags = {
    Name = "${var.module_prefix}-eip-nat-a"
  }
}
# Elastic IP for the nat-gateway in the public subnet pub-sub-2-b
resource "aws_eip" "eip-nat-b" {
  domain = "vpc"
  tags = {
    Name = "eip-nat-b"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip



# NAT gateway in public subnet pub-sub-a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_a_id

  tags = {
    Name = "${var.module_prefix}-nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}
# NAT gateway in public subnet pub-sub-b
resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_b_id

  tags = {
    Name = "${var.module_prefix}-nat-b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway



#----- AZ A
# create private route table Pri-RT-A and add route through NAT-GW-A
resource "aws_route_table" "pri-rt-a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a.id
  }

  tags = {
    Name = "${var.module_prefix}-pri-rt-a"
  }
}
#-- Web tier
# associate private subnet pri-sub-web-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-web-a-with-Pri-rt-a" {
  subnet_id      = var.pri_sub_web_a_id
  route_table_id = aws_route_table.pri-rt-a.id
}
#-- Data tier
# associate private subnet pri-sub-data-b with private route table Pri-rt-b
resource "aws_route_table_association" "pri-sub-data-b-with-Pri-rt-b" {
  subnet_id      = var.pri_sub_data_b_id
  route_table_id = aws_route_table.pri-rt-b.id
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association



#----- AZ B
# create private route table Pri-rt-b and add route through nat-b
resource "aws_route_table" "pri-rt-b" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-b.id
  }

  tags = {
    Name = "${var.module_prefix}-pri-rt-b"
  }
}

# Web tier
# associate private subnet pri-sub-web-b with private route table Pri-rt-b
resource "aws_route_table_association" "pri-sub-web-b-with-pri-rt-b" {
  subnet_id      = var.pri_sub_web_b_id
  route_table_id = aws_route_table.pri-rt-b.id
}

# Data tier
# associate private subnet pri-sub-data-a with private route table Pri-rt-b
resource "aws_route_table_association" "pri-sub-data-a-with-pri-rt-b" {
  subnet_id      = var.pri_sub_data_a_id
  route_table_id = aws_route_table.pri-rt-b.id
}
