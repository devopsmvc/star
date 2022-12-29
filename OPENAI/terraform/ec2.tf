#terraform for backend application in ap-south-1 region with 3 availability zones and subnets with reusable variables 
# Configure the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Define variables for the number of availability zones and subnets
variable "az_count" {
  default = 3
}

variable "subnet_count" {
  default = 3
}

# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create the availability zones
resource "aws_availability_zone" "my_azs" {
  count = var.az_count

  name = "ap-south-1a"
}

# Create the subnets
resource "aws_subnet" "my_subnets" {
  count           = var.subnet_count
  vpc_id          = aws_vpc.my_vpc.id
  cidr_block      = "10.0.${count.index}.0/24"
  availability_zone = aws_availability_zone.my_azs[count.index].name
}

# Create the security group for the backend application
resource "aws_security_group" "my_security_group" {
  name        = "my-backend-app-sg"
  description = "Security group for my backend application"
  vpc_id      = aws_vpc.my_vpc.id
}

# Create the backend application EC2 instance
resource "aws_instance" "my_backend_app" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnets[0].id
  security_groups = [aws_security_group.my_security_group.name]
}
