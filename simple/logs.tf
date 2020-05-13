# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "log_group_web" {
  name              = "/ecs/${var.name}-web"
  retention_in_days = 30

  tags = {
    Name = "${var.name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream_web" {
  name           = "${var.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group_web.name
}
