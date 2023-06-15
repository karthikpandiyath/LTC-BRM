resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
   tags = {
    Name        = var.igw_name
  }
}
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
    tags = {
    Name        =( "prod-public-subnet-${var.public_subnet_name[count.index]}")
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
    tags = {
    Name        =( "prod-public-subnet-${var.public_subnet_name[count.index]}")
  }
}
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidr_block[count.index]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
      tags = {
    Name        =( "prod-app-subnet-${var.private_subnet_name[0]}")
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidr_block1
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
      tags = {
    Name        =( "prod-app-subnet-${var.private_subnet_name[1]}")
  }
}

resource "aws_subnet" "private_subnet1_db" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_cidr_block1
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
      tags = {
    Name        =( "prod-db-subnet-${var.private_db_name}")
  }
}

resource "aws_subnet" "private_subnet2_db" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_cidr_block2
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
      tags = {
    Name        =( "prod-db-subnet-${var.private_db_name}")
  }
}
resource "aws_eip" "nat_gateway" {
  vpc = true
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet1.id
}
resource "aws_route_table" "RT_public_subnet" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table" "RT_private_subnet" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route" "public_internet_gateway_Subnet1" {
  route_table_id         = aws_route_table.RT_public_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
resource "aws_route" "private_nat_gateway_pvtsubnet1" {
  route_table_id         = aws_route_table.RT_private_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.RT_public_subnet.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.RT_public_subnet.id
}
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.RT_private_subnet.id
}
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.RT_private_subnet.id
}
resource "aws_route_table_association" "private_db_subnet_1" {
  subnet_id      = aws_subnet.private_subnet1_db.id
  route_table_id = aws_route_table.RT_private_subnet.id
}
resource "aws_route_table_association" "private_db_subnet_2" {
  subnet_id      = aws_subnet.private_subnet2_db.id
  route_table_id = aws_route_table.RT_public_subnet.id
}