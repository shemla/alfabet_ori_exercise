#####################################################################
# the role and policy to invoke Lambda function from the frontend

module "frontend_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.33.0"
  role_name_prefix ="frontend_assumable_role"
  role_description ="this role is the one frontend roles/users will be able to assume in order to access the backend api functions"
  
  create_role =true
  role_requires_mfa =false
  trusted_role_arns =[var.infra_create_role_arn]
  custom_role_policy_arns =[module.frontend_iam_policy.arn]
}

module "frontend_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.33.0"
  name_prefix ="frontend_iam_policy"
  description =""

  policy = data.aws_iam_policy_document.frontend_policy.json
}
#add lambda invoke permission
data "aws_iam_policy_document" "frontend_policy" {
  statement {
    sid       = "AllowLambdaInvoke"
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"] #add resource arn
  }
}


