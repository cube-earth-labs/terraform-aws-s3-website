terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.1"
    }
  }

  required_version = "~> 1.2"

  cloud {
    organization = "ericreeves-demo"
    hostname     = "app.terraform.io"

    workspaces {
      project = "Cube Earth Labs"
      name    = "terraform-aws-s3-website-tests"
    }
  }
}
