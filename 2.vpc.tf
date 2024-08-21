resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH ACCESS"
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    description      = "SSH ACCESS"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH ACCESS"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  

  ingress {
    description      = "SSH ACCESS"
    from_port        = 8080
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.app_name}-service-sg"
  }
}

resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.10.0.0/16"
  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "aws-public-subnet-01" {
  vpc_id     = aws_vpc.aws-vpc.id
  cidr_block = "10.10.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "aws-public-subnet-01"
  }
}

resource "aws_subnet" "aws-public-subnet-02" {
  vpc_id = aws_vpc.aws-vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1b"

   tags = {
    Name = "aws-public-subnet-02"
  }
  
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "aws-public-rt" {
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }
   tags = {
    Name = "java-app-public-rt"
  }
}
resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id      = aws_subnet.aws-public-subnet-01.id
  route_table_id = aws_route_table.aws-public-rt.id
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id     = aws_subnet.aws-public-subnet-02.id
  route_table_id = aws_route_table.aws-public-rt.id
}
