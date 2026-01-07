terraform {
  backend "s3" {
    bucket         = "greenleaf-terraform-state-user25"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "greenleaf-terraform-lock"
    encrypt        = true
  }
}
