output "api_url" {
  value = format("%s%s", aws_api_gateway_deployment.lambda.invoke_url, aws_api_gateway_resource.lambda_instances.path)
}