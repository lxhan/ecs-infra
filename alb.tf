locals {
  target_groups = ["blue", "green"]
  host_name     = "*.${var.aws_region}.elb.amazonaws.com"
}

resource "aws_alb" "main" {
  name            = "${var.app_name}-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_sg.id]
  tags            = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ALB" })
}

resource "aws_alb_target_group" "main" {
  count = length(local.target_groups)
  name  = "${var.app_name}-tg-${element(local.target_groups, count.index)}"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    matcher  = var.health_check_matcher
    path     = var.health_check_path
  }
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_alb_target_group.main.1.arn
      }
    }
  }
}

resource "aws_alb_listener_rule" "main" {
  count        = length(local.target_groups)
  listener_arn = aws_alb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.1.arn
  }

  condition {
    host_header {
      values = [local.host_name]
    }
  }
}
