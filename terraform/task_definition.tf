resource "aws_ecs_task_definition" "consumer_services" {
  for_each = toset(var.consumer_services)

  family                   = "${var.project_name}-${each.key}"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = "${aws_ecr_repository.cdc_consumer_orchestrator[each.key].repository_url}:latest"
      essential = true
      command   = ["python", "main.py"]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${each.key}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "consumer"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-${each.key}-task"
  }
}
