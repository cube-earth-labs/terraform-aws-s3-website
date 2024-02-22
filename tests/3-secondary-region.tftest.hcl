# Call the setup module to create a random bucket prefix
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

provider "aws" {
  region = "us-west-2"
}

run "create_bucket" {
  providers = {
    aws           = aws
  }

  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-secondary-aws-s3-website-test"
  }

  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == var.bucket_name
    error_message = "Invalid bucket name"
  }

  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}
