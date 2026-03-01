resource "aws_s3_bucket" "registry_bucket" {
  bucket        = "${var.s3_bucket_name}"

  tags = var.tags
}

