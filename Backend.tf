# Stores the statefile remotely 
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-karim"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}


# Creates a read-only copy of the statefile
data "terraform_remote_state" "read_only_state_file" {
  backend = "s3"
  config = {
    bucket     = "terraform-state-bucket-karim"
    key        = "terraform.tfstate"
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
    region     = "us-east-1"
  }
}
