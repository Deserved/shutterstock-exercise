locals {
  path_to_file = format("%s/package/function.zip", path.cwd)
}

variable "service" {
  description = "The unique name of the service that is used to set Lambda function name"
  type = string
}

variable "path_to_package" {
  description = "Path to Lambda package"
  type = string
}

variable "path_to_dataset" {
  description = "Path to dataset"
  type = string
}

variable "path_for_env" {
  description = "Path where env variables output for local testing"
  type = string
}

variable "runtime" {
  description = "The identifier of the lambda function's runtime"
  type = string
  default = "python3.7"
}

variable "handler" {
  description = "The name of the method within your code that Lambda calls to execute your function. The format includes the file name. It can also include namespaces and other qualifiers, depending on the runtime."
  type = string
  default = "function.handler"
}

variable "timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it. The default is 3 seconds. The maximum allowed value is 900 seconds."
  type = number
  default = 10
}