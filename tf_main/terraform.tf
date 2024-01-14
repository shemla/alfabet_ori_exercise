terraform {
  backend "s3" {
    #bucket         = var.devops_s3_name # BUCKET NAME
    key            = "tfstate"
    #region         = "us-east-1"
    #dynamodb_table = var.devops_dynamodb_name
    encrypt        = true
    #role_arn       = var.infra_create_role_arn
    access_key     = ""
    secret_key     = ""
  }

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
    role_arn     = var.infra_create_role_arn
    session_name = "terraform_session"

  }
}

