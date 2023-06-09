resource "aws_ecr_repository" "main" {
  name = "${var.project_name}-repo"
  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ECR" })
}
