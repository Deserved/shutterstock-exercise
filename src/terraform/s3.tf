resource "aws_s3_bucket" "lambda_packages_storage" {

  bucket = "shutterstock-lambda-packages"
  acl    = "private"

  tags = {
    Name = format("Bucket to store Lambda packages files")
  }
}

resource "aws_s3_bucket_object" "package_uploader" {

  bucket = aws_s3_bucket.lambda_packages_storage.bucket
  key    = format("lambdas/%s/function.%s.zip", var.service, filemd5(var.path_to_package))
  source = var.path_to_package

  acl = "private"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = format("Object contains archived source code for %s lambda service", var.service)
  }
}

resource "aws_s3_bucket" "dataset_storage" {

  bucket = "shutterstock-exercise-dataset"
  acl    = "private"

  tags = {
    Name = format("Bucket to store Shutterstock exercise dataset")
  }
}

resource "aws_s3_bucket_object" "dataset_uploader" {

  bucket = aws_s3_bucket.dataset_storage.bucket
  key    = "instances.json"
  source = var.path_to_dataset

  acl = "private"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = format("Object contains archived source code for %s lambda service", var.service)
  }
}