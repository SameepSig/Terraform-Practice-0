// -----------------VPCccccccccccccccccccc------------------------

resource "aws_vpc" "sameep_terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
  Name = "sameep_terraform_vpc"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

// ----------------Security Groupssssssssssssssss-------------

resource "aws_security_group" "sameep_sg" {
  name        = "sameep_sg_vpc_1_terraform"
  description = "sameep aws securitygroup built using terraform"
  vpc_id      = aws_vpc.sameep_terraform_vpc.id

  ingress{
    description = "sameep security group from terraform http"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 80
    protocol = "tcp"
    to_port     = 80
  }

  tags = {
    Name = "sameep-aws-sg-terraform"
    terraform = "true"
    silo = "intern2"
    owner = "sameep.sigdel"
    environment = "dev"
  }
}

//-------------Subnetsssssssssssssssssss-----------

resource "aws_subnet" "sameep_terraform_subnet_1" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sameep_terraform_subnet_1"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

resource "aws_subnet" "sameep_terraform_subnet_private_1" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "sameep_terraform_subnet_private_1"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

resource "aws_subnet" "sameep_terraform_subnet_private_2" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "sameep_terraform_subnet_private_2"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

// -----------------------EC2 Instance----------------------------

resource "aws_instance" "sameep_terraform_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.sameep_terraform_subnet_1.id
  key_name = var.key_name
  tags = {
    Name = "sameep-first-terraform-webserver"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

//----------------------Internet Gatewayyyyyyyyyyyyy------------------------------
resource "aws_internet_gateway" "sameep_internet_gateway_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  tags = {
    Name = "sameep_internet_gateway_1_terraform"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

//----------------------Elastic Ippppppppppppppppppppppp---------------------
resource "aws_eip" "sameep_elastic_ip_1" {
  //instance = aws_instance.sameep_terraform_ec2.id
  domain   = "vpc"
}

//----------------------NAT Gatewayyyyyyyyyyyyyyyyyy------------------------------
resource "aws_nat_gateway" "sameep_nat_gateway_1" {
  allocation_id = aws_eip.sameep_elastic_ip_1.id
  subnet_id     = aws_subnet.sameep_terraform_subnet_private_1.id

  tags = {
    Name = "sameep gw NAT"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.sameep_internet_gateway_1]
}



//----------------------Route Tableeeeeeeeeeeeeeeeeeee-----------------------------
resource "aws_route_table" "sameep_route_table_public_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sameep_internet_gateway_1.id
  }
}

resource "aws_route_table" "sameep_route_table_private_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.sameep_nat_gateway_1.id
  }
}

//----------------Route Table Associationnnnnnnnnnnn-----------------
resource "aws_route_table_association" "sameep_association_route_table_public_1" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_1.id
  route_table_id = aws_route_table.sameep_route_table_public_1.id
}

resource "aws_route_table_association" "sameep_association_route_table_private_1" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_private_1.id
  route_table_id = aws_route_table.sameep_route_table_private_1.id
}

resource "aws_route_table_association" "sameep_association_route_table_private_2" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_private_2.id
  route_table_id = aws_route_table.sameep_route_table_private_1.id
}


