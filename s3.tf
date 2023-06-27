resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.project_name}-codepipeline"
  tags   = merge(var.common_tags, { Name = "${var.common_tags["Project"]} S3 Bucket" })
}

resource "aws_s3_bucket_ownership_controls" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.codepipeline
  ]
}

resource "aws_s3_bucket_versioning" "codepipeline_versioning" {
  bucket = aws_s3_bucket.codepipeline.id
  versioning_configuration {
    status = "Enabled"
  }
}
