#terraform for backend application in ap-south-1 region with 3 availability zones and subnets with reusable variables 
# Configure the AWS provider
provider "aws" {
  region  = "ap-south-1"
}

# Define variables for the number of availability zones and subnets
variable "num_azs" {
  default = 3
}

variable "num_subnets" {
  default = 3
}

# Create an AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a list of availability zones
data "aws_availability_zones" "azs" {
  count = var.num_azs
}

# Create a list of subnets
resource "aws_subnet" "subnet" {
  count         = var.num_subnets
  vpc_id        = aws_vpc.vpc.id
  cidr_block    = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.azs[count.index].name
}

# Create an EC2 instance in each subnet
resource "aws_instance" "instance" {
  count       = var.num_subnets
  ami         = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id   = aws_subnet.subnet[count.index].id
}
