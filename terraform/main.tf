resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MainIGW"
  }
}

# Create NAT Gateway for Private Subnet
resource "aws_eip" "nat_ip" {
  domain = "vpc" # Use "domain" instead of "vpc = true"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NATGateway"
  }
}

# Route Table for Public Subnet (to allow access to the internet)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table for Private Subnet (using NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Associate Private Subnet with the Private Route Table
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_name
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 8081
    to_port     = 8083
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.main_vpc.id # Ensure the security group is in the correct VPC
}

resource "aws_instance" "web_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  # key_name      = "gupta"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "Arpit-EC2-Instance"
  }
}

resource "aws_ecr_repository" "mysql_repo" {
  name                 = "mysql-repo"  # Updated repository name
  image_tag_mutability = "MUTABLE"     # Allow tags to be mutable

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "mysql-repo"
  }
}

resource "aws_ecr_repository" "webapp_repo" {
  name                 = "webapp-repo"  # ECR repository name
  image_tag_mutability = "MUTABLE"      # Allow mutable tags

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "webapp-repo"
  }
}
