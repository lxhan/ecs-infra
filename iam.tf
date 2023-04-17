/* -------------------------------------------------------------------------- */
/*                                     ECS                                    */
/* -------------------------------------------------------------------------- */
data "aws_iam_policy_document" "ecs_task_assume_role_data" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_auto_scale_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_data.json
}

data "aws_iam_policy_document" "ecs_task_execution_role_data" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name   = "ecs-task-exec-policy"
  policy = data.aws_iam_policy_document.ecs_task_execution_role_data.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

/* -------------------------------------------------------------------------- */
/*                                CodePipeline                                */
/* -------------------------------------------------------------------------- */
data "aws_iam_policy_document" "codepipeline_assume_role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy_data" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.codepipeline.arn,
      "${aws_s3_bucket.codepipeline.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "codepipeline-policy"
  policy = data.aws_iam_policy_document.ecs_task_execution_role_data.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

/* -------------------------------------------------------------------------- */
/*                                 CodeDeploy                                 */
/* -------------------------------------------------------------------------- */
data "aws_iam_policy_document" "code_deploy_assume_role_data" {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code_deploy_role" {
  name               = "code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_assume_role_data.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy_role.name
}
