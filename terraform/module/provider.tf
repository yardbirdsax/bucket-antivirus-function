terraform {
  required_providers {
    aws = {
      version = "~> 3.0.0"
      source  = "hashicorp/aws"
    }
  }
}

data aws_caller_identity current {}