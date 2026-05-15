#################################################
# VPC
#################################################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "project2-vpc"
  }
}

#################################################
# PUBLIC SUBNET A
#################################################

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.AZ1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

#################################################
# PUBLIC SUBNET B
#################################################

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.AZ2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

#################################################
# PRIVATE SUBNET A
#################################################

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.AZ1

  tags = {
    Name = "private-subnet-a"
  }
}

#################################################
# PRIVATE SUBNET B
#################################################

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.AZ2

  tags = {
    Name = "private-subnet-b"
  }
}

#################################################
# Internet Gateway
#################################################

resource "aws_internet_gateway" "project2_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project2-igw"
  }
}

#################################################
# Public Route Table
#################################################

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project2-public-RT"
  }
}

#################################################
# Public Internet Route
#################################################

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.project2_igw.id
}

#################################################
# PUBLIC SUBNET ASSOCIATIONS
#################################################

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_RT.id
}

#################################################
# Private Route Table
#################################################

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project2-private-RT"
  }
}

#################################################
# Private Internet Route
#################################################

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_RT.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.project2_natgw.id
}

#################################################
# PRIVATE SUBNET ASSOCIATIONS
#################################################

resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_RT.id
}

#################################################
# ELASTIC IP FOR NAT GATEWAY
#################################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "project2-nat-eip"
  }
}

#################################################
# NAT GATEWAY
#################################################

resource "aws_nat_gateway" "project2_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "project2_NAT"
  }

  depends_on = [aws_internet_gateway.project2_igw]
}