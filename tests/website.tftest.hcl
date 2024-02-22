# Call the setup module to create a random bucket prefix
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "create_bucket" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
    error_message = "Invalid bucket name"
  }
}

run "validate_bucket_config" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  assert {
    condition     = aws_s3_bucket_acl.s3_bucket.acl == "public-read"
    error_message = "ACL is incorrect"
  }

  assert {
    condition     = aws_s3_object.index.key == "index.html"
    error_message = "Index object key is incorrect"
  }

  assert {
    condition     = aws_s3_object.index.content_type == "text/html"
    error_message = "Index object content type is incorrect"
  }

  assert {
    condition     = output.website_endpoint == "http://${aws_s3_bucket_website_configuration.s3_bucket.website_endpoint}/index.html"
    error_message = "Website endpoint is incorrect"
  }
}

run "validate_bucket_contents" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

  # Check error.html hash matches
  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}
