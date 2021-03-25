terraform {
  backend "s3" {
    bucket         = "encoded-replica-terraform-state"
    key            = "global/terraform-backend/s3/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "encoded-replica-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "encoded-replica-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "encoded-replica-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
