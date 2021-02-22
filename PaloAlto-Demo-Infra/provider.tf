terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.13.0"
    }

    eksctl = {
      source  = "mumoshu/eksctl"
      version = "0.15.1"
    }
  }
}

# Configuring AWS Provider
provider "aws" {
  region     = var.location
  access_key = var.access_key
  secret_key = var.secret_key
}

# Configuring eksctl Provider
provider "eksctl" {
}