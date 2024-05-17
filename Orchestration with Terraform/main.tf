# create a service on the cloud - launch an ec2 instance on aws
# HCL syntax key = value

# which part of AWS - which region
# provider "aws" {
    
#     region = var.region_name
#     #"eu-west-1"
# }
# aws-access-key-id = MUST NOT HARDCODE THE KEY
# aws-secret-access-key = MUST NOT HARDCORE THE KEY
# MUST NOT PUSH ANYTHING TO GITHUB UNTIL WE HAVE CREATED A .gitignore file together.
# which service/resource/s - ec2


provider "aws" {
    region = var.region_name
}

# Create a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = var.vpc_name
    }
}

# Create two subnets within the VPC
resource "aws_subnet" "app_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.app_subnet_cidr_block
    availability_zone = var.app_subnet_availability_zone

    tags = {
        Name = var.app_subnet_name
    }
}

resource "aws_subnet" "db_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.db_subnet_cidr_block
    availability_zone = var.db_subnet_availability_zone

    tags = {
        Name = var.db_subnet_name
    }
}

# Create a security group
resource "aws_security_group" "app_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name        = var.app_security_group_name
  description = var.app_security_group_description

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.ssh_protocol
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.http_protocol
    cidr_blocks = var.http_cidr_blocks
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = var.app_protocol
    cidr_blocks = var.app_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }
}

# Launch the EC2 instance within the VPC and in the first subnet
resource "aws_instance" "app_instance" {
    ami                         = var.app_ami_id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.app_subnet.id
    associate_public_ip_address = var.associate_public_ip_address
    key_name                    = var.key_name
    vpc_security_group_ids      = [aws_security_group.app_security_group.id]
    
    tags = {
        Name = var.app_instance_name
    }
}


# Define the GitHub provider
provider "github" {
  token = var.github_token
}

# Create the GitHub repository
resource "github_repository" "iac_github_automated_repo" {
  name        = "IaC-github-automated-repo"
  description = "Automated repository creation with Terraform"
  visibility  = "public"
}