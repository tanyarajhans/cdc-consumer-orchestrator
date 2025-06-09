resource "aws_ecs_service" "consumer_services" {
  for_each = toset(var.consumer_services)

  name            = "${var.project_name}-${each.key}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.consumer_services[each.key].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name = "${var.project_name}-${each.key}-service"
  }
}

# Application Auto Scaling
resource "aws_appautoscaling_target" "ecs_target" {
  for_each = toset(var.consumer_services)

  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.consumer_services[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  for_each = toset(var.consumer_services)

  name               = "${var.project_name}-${each.key}-scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  for_each = toset(var.consumer_services)

  name               = "${var.project_name}-${each.key}-scale-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80.0
  }
}
