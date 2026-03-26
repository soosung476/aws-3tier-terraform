# vpc 생성, terraform 내부이름은 main 
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
    # local.name_prefix는 {aws-3tier-tf-dev} = {var.project_name}-{var.environment}이다
  }
}

# 인터넷 게이트웨이 생성 내부이름은 main
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

# Public Subnets 구성이다. 내부이름은 public_2a, public_2c이다
resource "aws_subnet" "public_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2a_cidr
  availability_zone       = local.az_2a
  map_public_ip_on_launch = true
  # map_public_ip_on_launch는 퍼블릭 ip 자동할당기능이다. 퍼블릭의 경우 켜놓는게 일반적이다

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

# Private App Subnets 구성이다 내부이름은 private_app_2a, private_app_2c 이다
resource "aws_subnet" "private_app_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2a_cidr
  availability_zone = local.az_2a

  # 여기서는 mapmap_public_ip_on_launch 를 안했는데 기본값이 false이다 명시해주어도 된다
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

# Private DB Subnets 구성이다 내부이름은 private_db_2a, private_db_2c이다
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

# NAT 게이트웨이와 Elastic IP 할당이다
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip"
  }
}

# NAT Gateway는 2a에만 생성했다
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  # allocation_id = EIP 할당
  subnet_id     = aws_subnet.public_2a.id

  tags = {
    Name = "${local.name_prefix}-natgw"
  }

  depends_on = [aws_internet_gateway.main]
  # 인터넷 게이트웨이가 생성된 다음에 NAT게이트 웨이를 생성하도록 depends_on을 설정해준다
}

# 퍼블릭 라우트테이블 생성 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

# 라우트테이블을 생성할 때 aws_route_table 리소스 안에 route {}를 집어넣어서 인라인 블록으로 만드는 방법도 있지만
# 인라인 블록으로 route를 생성할 시 값이 바뀔 경우 라우트 테이블 전체 리소스가 변경되는 결과 
# 현재 보이는 것처럼 aws_route 리소스를 따로 만들어서 값을 집어넣으면 라우트가 바뀔 때 aws_route 리소스만 변경되어 더 권장되는 방식이라고 한다
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

# Private App 라우트테이블 생성
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

# Private DB 라우트테이블 생성
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