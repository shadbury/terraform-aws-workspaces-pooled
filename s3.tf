resource "random_id" "random" {
  byte_length = 8
}

resource "aws_s3_bucket" "s3" {
  count = var.workspaces_pooled_settings.app_settings_persistence == true ? 1 : 0

  bucket = "workspaces-pooled-application-persistence-${random_id.random.hex}"
}

resource "aws_s3_bucket_public_access_block" "block" {
  count = var.workspaces_pooled_settings.app_settings_persistence == true ? 1 : 0

  bucket = aws_s3_bucket.s3[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
