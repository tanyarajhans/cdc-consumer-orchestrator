terraform {
  backend "s3" {
    bucket         = "mercor-ecs-cdc-orchestrator-terraform"
    key            = "cdc-orchestrator/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mercor-ecs-cdc-orchestrator-terraform"
  }
}
