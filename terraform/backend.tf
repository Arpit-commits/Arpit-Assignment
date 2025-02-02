terraform {
  backend "s3" {
    bucket         = "169572237-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
