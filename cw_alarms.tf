resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "api-server-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "80"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "60"
  evaluation_periods  = "3"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "api-server-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "30"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "60"
  evaluation_periods  = "3"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}
