data "aws_iam_policy_document" "cdc_consumer_orchestrator" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cdc_consumer_orchestrator" {
  name               = "${var.project_name}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.cdc_consumer_orchestrator.json
}

resource "aws_iam_role_policy_attachment" "cdc_consumer_orchestrator" {
  role       = aws_iam_role.cdc_consumer_orchestrator.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
