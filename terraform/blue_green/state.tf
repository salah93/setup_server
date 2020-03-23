provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        region         = "us-east-2"
        bucket         = "salah-terraform-state"
        dynamodb_table = "salah-terraform-locks"
        key            = "state/releases/release_${var.release}.tfstate"
        encrypt        = true
    }
}
