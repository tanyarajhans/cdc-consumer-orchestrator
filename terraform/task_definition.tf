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
      image     = "${aws_ecr_repository.cdc_consumer_orchestrator[each.key].repository_url}:${var.image_tag}"
      essential = true
      command   = ["python", "main.py"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_services[each.key].name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = {
    Name = "${var.project_name}-${each.key}-task"
  }
}
