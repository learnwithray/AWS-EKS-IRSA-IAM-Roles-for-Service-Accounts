# Define Local Values in Terraform
locals {
  organization = var.organization
  team         = var.team
  environment  = var.environment
  name         = "${local.organization}-${local.team}-${local.environment}"
  tags = {
    organization = local.organization
    department   = local.team
    environment  = local.environment
  }
  eks_cluster_name = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_id
}