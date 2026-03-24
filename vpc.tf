resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2a_cidr
  availability_zone       = local.az_2a
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-2a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2c_cidr
  availability_zone       = local.az_2c
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-2c"
    Tier = "public"
  }
}

# Private App Subnets
resource "aws_subnet" "private_app_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2a_cidr
  availability_zone = local.az_2a

  tags = {
    Name = "${local.name_prefix}-private-app-2a"
    Tier = "app"
  }
}

resource "aws_subnet" "private_app_2c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2c_cidr
  availability_zone = local.az_2c

  tags = {
    Name = "${local.name_prefix}-private-app-2c"
    Tier = "app"
  }
}

# Private DB Subnets
resource "aws_subnet" "private_db_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_2a_cidr
  availability_zone = local.az_2a

  tags = {
    Name = "${local.name_prefix}-private-db-2a"
    Tier = "db"
  }
}

resource "aws_subnet" "private_db_2c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_2c_cidr
  availability_zone = local.az_2c

  tags = {
    Name = "${local.name_prefix}-private-db-2c"
    Tier = "db"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip"
  }
}

# NAT Gateway (single NAT for beginner/minimum version)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_2a.id

  tags = {
    Name = "${local.name_prefix}-natgw"
  }

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_2a" {
  subnet_id      = aws_subnet.public_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2c" {
  subnet_id      = aws_subnet.public_2c.id
  route_table_id = aws_route_table.public.id
}

# Private App Route Table
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-private-app-rt"
  }
}

resource "aws_route" "private_app_nat" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_app_2a" {
  subnet_id      = aws_subnet.private_app_2a.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_app_2c" {
  subnet_id      = aws_subnet.private_app_2c.id
  route_table_id = aws_route_table.private_app.id
}

# Private DB Route Table
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-private-db-rt"
  }
}

resource "aws_route" "private_db_nat" {
  route_table_id         = aws_route_table.private_db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_db_2a" {
  subnet_id      = aws_subnet.private_db_2a.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_route_table_association" "private_db_2c" {
  subnet_id      = aws_subnet.private_db_2c.id
  route_table_id = aws_route_table.private_db.id
}