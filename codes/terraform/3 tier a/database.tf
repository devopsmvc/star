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

# main.tf

module "backend" {
  source = "./backend"
}

module "frontend" {
  source = "./frontend"
}

module "database" {
  source = "./database"
}
