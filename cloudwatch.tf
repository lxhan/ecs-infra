/* -------------------------------------------------------------------------- */
/*                                   Metrics                                  */
/* -------------------------------------------------------------------------- */
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


/* -------------------------------------------------------------------------- */
/*                                    Logs                                    */
/* -------------------------------------------------------------------------- */
resource "aws_cloudwatch_log_group" "api_server_log_group" {
  name              = "/ecs/api-server"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "api_server_log_stream" {
  name           = "api-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.api_server_log_group.name
}
