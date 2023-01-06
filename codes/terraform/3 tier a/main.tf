# Configure the AWS provider
provider "aws" {
  region  = "ap-south-1"
}

# Create an AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a list of availability zones
data "aws_availability_zones" "azs" {
  count = 3
}

# Create a public subnet in each availability zone
resource "aws_subnet" "public_subnet" {
  count         = 3
  vpc_id        = aws_vpc.vpc.id
  cidr_block    = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.azs[count.index].name
  map_public_ip_on_launch = true
}

# Create a private subnet in each availability zone
resource "aws_subnet" "private_subnet" {
  count         = 3
  vpc_id        = aws_vpc.vpc.id
  cidr_block    = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 3)
  availability_zone = data.aws_availability_zones.azs[count.index].name
  map_public_ip_on_launch = false
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Create a route table for the public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_route_table_association" {
  count       = 3
  subnet_id   = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a load balancer
resource "aws_lb" "lb" {
  name            = "my-load-balancer"
  internal        = false
  load_balancer_type = "application"
  subnets         = aws_subnet.public_subnet.*.id
}

# Create a target group for the load balancer
resource "aws_lb_target_group" "tg" {
  name       = "my-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
}

# Create a listener for the
