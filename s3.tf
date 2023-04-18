resource "aws_s3_bucket" "codepipeline" {
  bucket = "codepipeline"
  tags   = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} S3 Bucket" })
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
  tags   = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} S3 Bucket ACL" })
}
