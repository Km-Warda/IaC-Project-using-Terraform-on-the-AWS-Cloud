# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table Association for the Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "${var.aws_region}b"
}

# Instance Security Group
resource "aws_security_group" "instance_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  # Inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidr
  }

  # Inbound rule for Port 3000
  ingress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidr
  }

  # Outbound rule (allow all traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web_instances" {
  count                   = 1
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.public_subnet.id
  vpc_security_group_ids  = [aws_security_group.instance_security_group.id]
}

# RDS Security Group
resource "aws_security_group" "rds_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  # Inbound rule for MySQL Port 3306
  ingress {
    from_port       = var.rds_mysql_port
    to_port         = var.rds_mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.instance_security_group.id]
  }
  # Egress: all allowed (stateful) 
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id]
}

# RDS Instance
resource "aws_db_instance" "rds_instance" {
  identifier             = "mydatabase"
  allocated_storage      = var.rds_allocated_storage
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_type
  username               = var.rds_username
  password               = var.rds_password
  name                   = "mydatabase"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
}
