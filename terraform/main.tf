provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "terraform" {
  vpc_id = aws_vpc.terraform.id
}

resource "aws_route_table" "terraform" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform.id
  }
}

resource "aws_subnet" "terraform" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.1.0/24"

  route_table_id = aws_route_table.terraform.id
}

resource "aws_security_group" "terraform" {
  name   = "terraform"
  vpc_id = aws_vpc.terraform.id

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
  subnet_id = aws_subnet.terraform.id
}

resource "aws_eip" "terraform" {
  vpc      = true
  network_interface = aws_network_interface.terraform.id
}

resource "aws_instance" "terraform" {
  ami           = "ami-07ffb2f4d65357b42"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.terraform.id
  }

  /* connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  } */

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2"
    ]
  }
}

