# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
# reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

### Enabling IAM Roles for Service Accounts

data "aws_iam_policy_document" "eks_cluster_irsa_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.terraform_remote_state.eks_terraform_cluster_oidc.outputs.eks_cluster_openid_connect_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${data.terraform_remote_state.eks_terraform_cluster_oidc.outputs.eks_cluster_openid_connect_provider_arn_extract_from_arn}:sub"
      values   = ["system:serviceaccount:default:${local.name}-irsa-sa"]
    }
  }
  version = "2012-10-17"
}

### Create IAM Role for EKS Cluster IRSA
resource "aws_iam_role" "eks_cluster_irsa_role" {
  name               = "${local.name}-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_irsa_policy.json
  tags = {
    tag-key = "${local.name}-irsa-role"
  }
}


### Associate IAM Role eks_cluster_irsa_role and Policy 
resource "aws_iam_role_policy_attachment" "eks_cluster_irsa_role_s3_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.eks_cluster_irsa_role.name
}


### Output of eks_cluster_irsa_role  Role for EKS Cluster IRSA 
output "eks_cluster_irsa_role_arn" {
  description = "EKS Cluster IRSA Role ARN"
  value       = aws_iam_role.eks_cluster_irsa_role.arn
}
