locals {
  lambda_environment_variables = {
    S3_DATASET_BUCKET     = aws_s3_bucket_object.dataset_uploader.bucket
    S3_DATASET_BUCKET_KEY = aws_s3_bucket_object.dataset_uploader.key
  }
}

resource "aws_lambda_function" "lambda" {

  depends_on = [
    aws_s3_bucket_object.package_uploader
  ]

  function_name = var.service

  runtime = var.runtime
  handler = var.handler
  timeout = var.timeout
  publish = true

  s3_bucket = aws_s3_bucket.lambda_packages_storage.bucket
  s3_key = format("lambdas/%s/function.%s.zip", var.service, filemd5(var.path_to_package))

  role = aws_iam_role.lambda.arn
  source_code_hash = base64sha256(format("%s%s%s", filemd5(var.path_to_package), jsonencode(local.lambda_environment_variables), aws_iam_role.lambda.arn))

  environment {
    variables = local.lambda_environment_variables
  }

  tags = {
    Name = format("Lambda service %s", var.service)
  }
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = format(
    "arn:aws:execute-api:eu-west-1:328970118254:*"
//  ,
//    aws_api_gateway_deployment.lambda.execution_arn
//    aws_api_gateway_method.lambda.http_method,
//    aws_api_gateway_resource.lambda.path
  )
}