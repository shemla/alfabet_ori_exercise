terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11.0"
    }
  }
  required_version = ">= 1.5.4"
}
provider "aws" {
  region = var.aws_region
  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false

  assume_role {
    role_arn     = var.role_arn
    session_name = "terraform_session"
  }
}


output "tfstr1_init" {
  description = "the full string to be used to initialize terraform main infra"
  value = "terraform init -reconfigure -backend-config='bucket=${aws_s3_bucket.terraform_state.bucket}' -backend-config='region=${var.aws_region}' -backend-config='dynamodb_table=${var.devops_dynamodb_name}' -backend-config='role_arn=${var.role_arn}'"
}
output "tfstr2_apply" {
  description = "the full string to be used to apply terraform main changes"
  value       = "terraform apply -auto-approve -var='infra_create_role_arn=${var.role_arn}' -var='devops_s3_name=${aws_s3_bucket.terraform_state.bucket}' -var='devops_dynamodb_name=${var.devops_dynamodb_name}' -var='aws_region=${var.aws_region}'"
}
