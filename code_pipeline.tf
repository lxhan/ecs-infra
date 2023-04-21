resource "aws_codepipeline" "main" {
  name     = "api-server-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Artifact"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = 1
      run_order        = 1
      output_artifacts = ["SourceArtifact"]

      configuration = {
        S3Bucket             = aws_s3_bucket.codepipeline.bucket
        S3ObjectKey          = "artifact.zip"
        PollForSourceChanges = true
      }
    }

    action {
      name             = "DockerImage"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = 1
      run_order        = 1
      output_artifacts = ["ECRImage"]

      configuration = {
        ImageTag       = "dev"
        RepositoryName = aws_ecr_repository.main.name
      }
    }
  }

  # stage {
  #   name = "Approval"

  #   action {
  #     name             = "AWS-Admin-Approval"
  #     category         = "Approval"
  #     owner            = "AWS"
  #     provider         = "Manual"
  #     version          = 1
  #     run_order        = 1
  #     input_artifacts  = []
  #     output_artifacts = []

  #     configuration = {
  #       CustomData = "Please verify the terraform plan output on the Plan stage and only approve this step if you see expected changes!"
  #     }
  #   }
  # }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      input_artifacts = ["SourceArtifact", "ECRImage"]
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = 1
      run_order       = 1

      configuration = {
        ApplicationName                = aws_codedeploy_app.main.name
        Image1ArtifactName             = "ECRImage"
        TaskDefinitionTemplateArtifact = "SourceArtifact"
        Image1ContainerName            = "IMAGE1_NAME"
        AppSpecTemplateArtifact        = "SourceArtifact"
        DeploymentGroupName            = aws_codedeploy_deployment_group.api_server_dg.deployment_group_name
      }
    }
  }

  depends_on = [
    aws_s3_bucket.codepipeline
  ]

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} CodePipeline" })
}
