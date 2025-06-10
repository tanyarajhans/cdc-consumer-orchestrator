resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name = "/ecs/cluster/${var.project_name}"
  tags = {
    Name = "${var.project_name}-cluster-logs"
  }
}

resource "aws_cloudwatch_log_group" "ecs_services" {
  for_each = toset(var.consumer_services)

  name = "/ecs/service/${var.project_name}-${each.key}"

  tags = {
    Name = "${var.project_name}-${each.key}-logs"
  }
}
