resource "aws_api_gateway_rest_api" "lambda" {
  name        = "LambdaAPI"
  description = "API integrates with Lambda function"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "lambda_instances" {
  path_part   = "instances"
  parent_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.lambda.id
}

resource "aws_api_gateway_resource" "lambda_instances_id" {
  path_part   = "{InstanceId}"
  parent_id   = aws_api_gateway_resource.lambda_instances.id
  rest_api_id = aws_api_gateway_rest_api.lambda.id
}

resource "aws_api_gateway_method" "lambda_instances" {
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  resource_id   = aws_api_gateway_resource.lambda_instances.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "lambda_instances_id" {
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  resource_id   = aws_api_gateway_resource.lambda_instances_id.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.InstanceId" = true
  }
}

resource "aws_api_gateway_deployment" "lambda" {
  depends_on = [
    aws_api_gateway_integration.lambda_instances_id
  ]

  stage_name  = "api"

  rest_api_id = aws_api_gateway_rest_api.lambda.id
}

resource "aws_api_gateway_integration" "lambda_instances" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_resource.lambda_instances.id
  http_method             = aws_api_gateway_method.lambda_instances.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_instances_id" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_resource.lambda_instances_id.id
  http_method             = aws_api_gateway_method.lambda_instances_id.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn

  request_parameters =  {
    "integration.request.path.InstanceId" = "method.request.path.InstanceId"
  }


}