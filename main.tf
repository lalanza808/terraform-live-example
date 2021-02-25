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

resource "aws_s3_bucket" "b" {
  bucket = "lance-atlantis-pr-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
