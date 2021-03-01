#
# Resources Created
#  * VPC
#  * Private and Public Subnets
#  * IGW and NAT GW
#  * Route Tables to Associate Subnets with IGW and NAT GW
#


# Fetching AZ Details from AWS
data "aws_availability_zones" "available" {}

# Creating AWS VPC
resource "aws_vpc" "primary" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "primary"
  }
}

# Creating AWS IGW and attaching it to VPC
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "primary"
  }
}

# Creating public Subnet in two AZ and assigning IP CIDR to them
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# Creating private Subnet in two AZ and assigning IP CIDR to them
resource "aws_subnet" "private_subnet_az" {
  count  =  2
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

# Creating Elastic IP for NAT Gateway 
resource "aws_eip" "nat" {
  vpc = true
}

# Creating NAT Gateway for internet access to private subnet 
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat-gw NAT"
  }
  depends_on = [aws_internet_gateway.internet-gw]
}

# Creating Route Table for Public Subnet and routing traffic through IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associating Public Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Creating Route Table for Private Subnet and routing traffic through NAT Gateway
resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}

# Associating Private Route Table with Private Subnets
resource "aws_route_table_association" "private" {
  count = 2
  subnet_id      = aws_subnet.private_subnet_az[count.index].id
  route_table_id = aws_route_table.pvt_rt.id
}