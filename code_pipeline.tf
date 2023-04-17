resource "aws_codepipeline" "main" {
  name     = "api-server-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Approval"

    action {
      run_order        = 1
      name             = "AWS-Admin-Approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
      input_artifacts  = []
      output_artifacts = []

      configuration = {
        CustomData = "Please verify the terraform plan output on the Plan stage and only approve this step if you see expected changes!"
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      run_order        = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        S3Bucket             = "codepipeline"
        S3ObjectKey          = "artifact.zip"
        PollForSourceChanges = true
      }
    }

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      run_order        = "1"
      output_artifacts = ["ECRImage"]

      configuration = {
        ImageTag       = "dev"
        RepositoryName = "api-server"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      input_artifacts = ["SourceArtifact", "ECRImage"]
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = "2"

      configuration = {
        ApplicationName                = "api-server-deploy"
        ImageArtifactName              = "ECRImage"
        TaskDefinitionTemplateArtifact = "SourceArtifact"
        ImageContainerName             = "api-server"
        AppSpecTemplateArtifact        = "SourceArtifact"
        DeploymentGroupName            = "api-server-dg"
      }
    }
  }
}
