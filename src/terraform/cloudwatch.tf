resource "aws_cloudwatch_log_group" "lambda" {
  name  = format("/aws/lambda/%s", var.service)

  retention_in_days = 14

  tags = {
    Name = format("Group to store logs from %s lambda service", var.service)
  }
}