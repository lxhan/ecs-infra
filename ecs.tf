resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ECS Cluster" })
}

resource "aws_ecs_service" "main" {
  name          = "${var.app_name}-service"
  cluster       = aws_ecs_cluster.main.id
  desired_count = var.app_count
  launch_type   = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.1.arn
    container_name   = "${var.app_name}-container"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.main
  ]

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ECS Service" })
}
