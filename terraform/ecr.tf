resource "aws_ecr_repository" "cdc_consumer_orchestrator" {
  for_each = toset(var.consumer_services)
  name     = "${var.project_name}-${each.key}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}
