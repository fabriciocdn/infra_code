# 1. Criar a Política de Acesso ao S3
resource "aws_iam_policy" "harbor_s3_policy" {
  name = "HarborS3StoragePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetBucketLocation", "s3:ListBucketMultipartUploads"]
        Resource = [aws_s3_bucket.registry_bucket.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListMultipartUploadParts", "s3:AbortMultipartUpload"]
        Resource = ["${aws_s3_bucket.registry_bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_user" "harbor_user" {
  name = "harbor-s3-user"
}

resource "aws_iam_access_key" "harbor_keys" {
  user = aws_iam_user.harbor_user.name
}

resource "aws_iam_user_policy_attachment" "harbor_static_attach" {
  user       = aws_iam_user.harbor_user.name
  policy_arn = aws_iam_policy.harbor_s3_policy.arn
}

output "harbor_s3_access_key" {
  value = aws_iam_access_key.harbor_keys.id
}

output "harbor_s3_secret_key" {
  value     = aws_iam_access_key.harbor_keys.secret
  sensitive = true
}