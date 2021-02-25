provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "missionsa-atlantis-backend"
    key = "terraform.tfstate"
    dynamodb_table = "missionsa-atlantis-backend"
  }
}
