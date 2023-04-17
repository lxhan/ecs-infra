resource "aws_security_group" "lb_sg" {
  name        = "api-server-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.allow_all_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-task-sg"
  description = "Allows inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }
}
