terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "GreenLeaf"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
