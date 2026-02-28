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

resource "aws_iam_role" "harbor_s3_role" {
  name = "harbor-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks-cluster.oidc}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks-cluster.oidc}:sub" = "system:serviceaccount:harbor:harbor-registry-sa"
            "${module.eks-cluster.oidc}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "harbor_s3_attach" {
  role       = aws_iam_role.harbor_s3_role.name
  policy_arn = aws_iam_policy.harbor_s3_policy.arn
}