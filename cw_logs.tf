resource "aws_cloudwatch_log_group" "api_server_log_group" {
  name              = "/ecs/api-server"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "api_server_log_stream" {
  name           = "api-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.api_server_log_group.name
}
