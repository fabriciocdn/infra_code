module "vpc_project" {
  source = "github.com/fabriciocdn/terraform_aws_eks//modules/network?ref=main"

  cidr_block = var.vpc_cidr

  tags = var.tags

}

module "eks-cluster" {
  source = "github.com/fabriciocdn/terraform_aws_eks//modules/cluster?ref=main"

  public_subnet_1a = module.vpc_project.eks_subnet_public_1a
  public_subnet_1b = module.vpc_project.eks_subnet_public_1b

  tags = var.tags
}

module "eks-managed-node-group" {
  source = "github.com/fabriciocdn/terraform_aws_eks//modules/managed-node-group?ref=main"

  cluster_name = module.eks-cluster.cluster_name

  eks_subnet_private_1a = module.vpc_project.eks_subnet_private_1a
  eks_subnet_private_1b = module.vpc_project.eks_subnet_private_1b
  instance_types        = var.instance_types
  tags                  = var.tags

}

module "aws-load-balancer-controller" {
  source = "github.com/fabriciocdn/terraform_aws_eks//modules/aws-load-balancer-controller?ref=main"

  cluster_name = module.eks-cluster.cluster_name
  oidc         = module.eks-cluster.oidc

  vpc_id = module.vpc_project.vpc_id

  oidc_arn = module.eks-cluster.oidc_arn
  oidc_url = module.eks-cluster.oidc_url

  tags = var.tags
}

