output "example" {
  value = <<EXAMPLE


You can try these REST API calls:
curl -i ${format("%s%s", aws_api_gateway_deployment.lambda.invoke_url, aws_api_gateway_resource.lambda_instances.path)}
curl -i ${format("%s%s/i-00b7fb83a362506ef", aws_api_gateway_deployment.lambda.invoke_url, aws_api_gateway_resource.lambda_instances.path)}


EXAMPLE
}