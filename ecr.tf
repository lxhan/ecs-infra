resource "aws_ecr_repository" "main" {
  name = "${var.app_name}-repo"
  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ECR" })
}
