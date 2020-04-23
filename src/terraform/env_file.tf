resource "local_file" "env_file" {
  content     = <<JSON
{
  "S3_DATASET_BUCKET" : "${aws_s3_bucket_object.dataset_uploader.bucket}",
  "S3_DATASET_BUCKET_KEY" : "${aws_s3_bucket_object.dataset_uploader.key}"
}
JSON

  filename = var.path_for_env
}