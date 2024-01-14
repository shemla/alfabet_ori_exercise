module "events_crud_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "events_crud_lambda"
  description   = "events CRUD lambda function (api lambda)"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../code/events_crud_lambda"

  attach_policy = true
  policy = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"

  
}