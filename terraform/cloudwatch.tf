resource "aws_cloudwatch_log_group" "cdc_consumer" {
  name              = "/ecs/cdc-consumer"
  retention_in_days = 7
}
