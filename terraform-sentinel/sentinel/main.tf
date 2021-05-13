terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.38.0"
    }
  }
  required_version = "~> 0.15"
  backend "remote" {
    organization = "rachel-demo"
    workspaces {
      name = "sentinel-example"
    }
  }
}



variable "region" {
  description = "This is the cloud hosting region where Terraform deploys your webapp"
}

variable "prefix" {
  description = "This is the environemnt where Terraform deploys your webapp"
}

provider "aws" {
  region = var.region
}
resource "random_pet" "petname" {
  length    = 3
  separator = "-"
}
resource "aws_s3_bucket" "demo" {
  bucket = "${var.prefix}-${random_pet.petname.id}"
  acl    = "public-read"
  tags = {
    Name        = "HashiCorp"
    Environment = "Learn"
  }
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.prefix}-${random_pet.petname.id}/*"
            ]
        }
    ]
}
EOF
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  force_destroy = true
}
resource "aws_s3_bucket_object" "demo" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket.demo.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"
}

output "dev_website_endpoint" {
  value = "http://${aws_s3_bucket.demo.website_endpoint}/index.html"
}
