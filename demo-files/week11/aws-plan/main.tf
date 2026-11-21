# Week 11, DEMO 4 - the same language, a real cloud. PLAN ONLY. NEVER APPLY.
# The keys are fake. The three skip_* settings stop the provider from checking
# them with AWS, so `terraform plan` works with no account and no AWS call.
# `terraform apply` would fail at its first real API call - and must.
terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.66"
    }
  }
}

provider "aws" {
  region                      = "eu-central-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

# The network: a VPC and one subnet (Yandex Cloud: yandex_vpc_network, yandex_vpc_subnet)
resource "aws_vpc" "main" {
  cidr_block = "10.20.0.0/16"
  tags       = { Name = "inf345-demo" }
}

resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.20.1.0/24"
  tags       = { Name = "inf345-app" }
}

# A firewall: only port 8080, only from inside the VPC
resource "aws_security_group" "app" {
  name   = "inf345-notes"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

# A virtual machine (Yandex Cloud: yandex_compute_instance)
resource "aws_instance" "app" {
  ami                    = "ami-0123456789abcdef0" # a placeholder: plan does not look it up
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.app.id
  vpc_security_group_ids = [aws_security_group.app.id]
  tags                   = { Name = "inf345-notes" }
}

# Object storage for backups (Yandex Cloud: yandex_storage_bucket)
resource "aws_s3_bucket" "backups" {
  bucket = "inf345-notes-backups-demo"
}
