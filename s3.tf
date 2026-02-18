resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false

}

resource "aws_s3_bucket" "registry_bucket" {
  bucket        = "${var.s3_bucket_name}-${random_string.suffix.result}"
  force_destroy = true

  tags = var.tags
}

