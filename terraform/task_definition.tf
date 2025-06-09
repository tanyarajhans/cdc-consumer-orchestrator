resource "aws_ecs_task_definition" "cdc_consumer_orchestrator" {
  for_each = toset(var.consumer_services)

  family                   = "${var.project_name}-${each.key}"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.cdc_consumer_orchestrator.arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = "${aws_ecr_repository.cdc_consumer_orchestrator[each.key].repository_url}:{var.image_tag}"
      essential = true
      command   = ["python", "main.py"]
    }
  ])

  tags = {
    Name = "${var.project_name}-${each.key}-task"
  }
}
