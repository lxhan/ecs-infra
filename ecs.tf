resource "aws_ecs_cluster" "main" {
  name = "api-server-cluster"
}

data "template_file" "container_definition" {
  template = file("./templates/container_def.json.tpl")
  vars = {
    docker_image = aws_ecr_repository.main.repository_url
    app_port     = var.app_port
    task_cpu     = var.task_cpu
    task_memory  = var.task_memory
    aws_region   = var.aws_region
  }
}

resource "aws_ecs_task_definition" "ecs_td" {
  family                   = "api-server-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = data.template_file.container_definition.rendered
}

resource "aws_ecs_service" "main" {
  name            = "api-server-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ecs_td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.blue.id
    container_name   = "api-server"
    container_port   = var.app_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.green.id
    container_name   = "api-server"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.app_listener,
    aws_iam_role_policy_attachment.ecs_task_execution_role_attach
  ]
}
