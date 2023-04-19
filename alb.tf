resource "aws_alb" "main" {
  name            = "${var.app_name}-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_sg.id]
  tags            = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ALB" })
}

resource "aws_alb_target_group" "blue" {
  name        = "${var.app_name}-tg-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    matcher  = var.health_check_matcher
    path     = var.health_check_path
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} TG" })
}

resource "aws_alb_target_group" "green" {
  name        = "${var.app_name}-tg-2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    matcher  = var.health_check_matcher
    path     = var.health_check_path
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} TG" })
}

resource "aws_alb_listener" "app_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_alb_target_group.blue.arn
      }
      target_group {
        arn = aws_alb_target_group.green.arn
      }
    }
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ALB Listener" })
}

resource "aws_alb_listener" "https_redirect" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} ${var.common_tags["Environment"]} ALB Listener" })
}
