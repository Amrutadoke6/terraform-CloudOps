terraform {
  backend "s3" {
    bucket         = "amruta-tfstate-bucket"
    key            = "cloudops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

