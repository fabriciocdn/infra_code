# Global
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# S3
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# node group mng
variable "instance_types" {
  description = "Instance type for the EKS managed node group"
  type        = list(string)
}