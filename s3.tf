resource "aws_s3_bucket" "codepipeline" {
  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} S3 Bucket" })
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
