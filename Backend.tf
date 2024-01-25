terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-karim"
    key            = "terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
  }
}