locals {
  account_id                     = "332040500790"
  terraform_state_bucket         = "mercor-ecs-cdc-orchestrator-terraform"
  terraform_state_key            = "cdc-orchestrator/terraform.tfstate"
  terraform_state_region         = "us-east-1"
  terraform_state_dynamodb_table = "mercor-ecs-cdc-orchestrator-terraform"
}