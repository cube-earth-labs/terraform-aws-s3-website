run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "bucket_name_validation" {
  command = plan

  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  assert {
    condition     = var.bucket_name != null
    error_message = "Bucket name should not be null."
  }
}