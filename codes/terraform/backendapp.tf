#terraform for backend application in ap-south-1 region with 3 availability zones and subnets with reusable variables 

# Configure the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Define reusable variables for the availability zones and subnets
variable "azs" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Create a VPC with three availability zones and subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block = var.subnet_cidrs[count.index]

  tags = {
    Name = "main-${var.azs[count.index]}"
  }
}

# Create an application load balancer
resource "aws_lb" "main" {
  name = "main"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb.id]
  subnets = aws_subnet.main.*.id

  tags = {
    Name = "main"
  }
}

# Create a security group for the load balancer
resource "aws_security_group" "lb" {
  name = "lb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb"
  }
}
