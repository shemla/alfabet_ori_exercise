variable "aws_region" {
  description = "Name of the AWS region to build the infrastructure in"
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "env_name" {
  description = "environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
  nullable    = false
  validation {
    condition     = var.env_name == "dev" || var.env_name == "staging" || var.env_name == "prod"
    error_message = "Please select a valid environment name (dev/staging/prod)"
  }
}

variable "role_arn" {
  description = "arn of the IAM role to be assumed by Terraform in order to build the infrastructure"
  type        = string
  default     = ""
  nullable    = false
}

variable "devops_s3_prefix" {
  description = "name for the backend Terraform devops S3 bucket, which stores the Terraform state file"
  type        = string
  default     = "devops-tf-state-bucket"
}

variable "devops_dynamodb_name" {
  description = "name for the backend Terraform devops DynamoDB table, which stores a lock item for the Terraform state file, that will prevent edditing by several users in parallel and subsequent errors"
  type        = string
  default     = "devops-state-locking-table2"
}

#random pet names with suffix for avoiding having buckets with the same name in the same region
resource "random_string" "s3_tfstate_bucket_name_suffix" {
  length  = 8
  special = false
  upper   = false
}