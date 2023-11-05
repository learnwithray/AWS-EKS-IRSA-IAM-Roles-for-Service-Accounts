# Reference: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1
# Resource: Kubernetes Service Account
resource "kubernetes_service_account_v1" "eks_cluster_irsa_sa" {
  metadata {
    name = "${local.name}-irsa-sa"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_irsa_role.arn
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_irsa_role_s3_policy_attach,
    # aws_iam_role_policy_attachment.eks_cluster_irsa_role_ec2_policy_attach
  ]
}
