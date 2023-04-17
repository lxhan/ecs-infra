resource "aws_s3_bucket" "codepipeline" {
  bucket = "codepipeline"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
}
