provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
    Location = "Bangalore"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"


  tags = {
    Name =  "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public route table - terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "10.30.1.0/24"
  map_public_ip_on_launch = false
#  route_table_id = aws_route_table.public.id

  tags = {
      Name = "Public-Subnet"
    }
}


resource "aws_security_group" "terraform" {
  name   = "terraform"
  vpc_id = aws_vpc.terraform_vpc.id

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
}

resource "aws_network_interface" "terraform" {
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.terraform.id]

  tags = {
    Name = "terraform"
  }
}


resource "aws_eip" "eip-nat" {
  vpc = true

  
  tags = {
    Name = "EIP1"
  }
}

resource "aws_eip_association" "eip_assoc" {
#  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.eip-nat.id
  network_interface_id = aws_network_interface.terraform.id
}


resource "aws_instance" "terraform" {
  ami           = "ami-07ffb2f4d65357b42"
  instance_type = "t2.micro"
  key_name = "devops"
  /* associate_public_ip_address = "true" */

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "Terraform"
  }
  network_interface {
    device_index            = 0
    network_interface_id    = "${aws_network_interface.terraform.id}"
  }
}



