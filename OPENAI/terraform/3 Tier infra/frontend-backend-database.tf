# backend.tf

# Configure the AWS provider
provider "aws" {
  region  = "ap-south-1"
}

# Define variables for the backend resources
variable "backend_instance_type" {
  default = "t2.micro"
}

variable "backend_ami" {
  default = "ami-12345678"
}

variable "backend_subnet_id" {
  default = ""
}

# Create an EC2 instance for the backend
resource "aws_instance" "backend" {
  ami           = var.backend_ami
  instance_type = var.backend_instance_type
  subnet_id     = var.backend_subnet_id
}

# frontend.tf

# Define variables for the frontend resources
variable "frontend_instance_type" {
  default = "t2.micro"
}

variable "frontend_ami" {
  default = "ami-12345678"
}

variable "frontend_subnet_id" {
  default = ""
}

# Create an EC2 instance for the frontend
resource "aws_instance" "frontend" {
  ami           = var.frontend_ami
  instance_type = var.frontend_instance_type
  subnet_id     = var.frontend_subnet_id
}

# database.tf

# Define variables for the database resources
variable "database_instance_type" {
  default = "t2.micro"
}

variable "database_ami" {
  default = "ami-12345678"
}

variable "database_subnet_id" {
  default = ""
}

# Create an EC2 instance for the database
resource "aws_instance" "database" {
  ami           = var.database_ami
  instance_type = var.database_instance_type
  subnet_id     = var.database_subnet_id
}
