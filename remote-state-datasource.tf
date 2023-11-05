data "terraform_remote_state" "eks_terraform_cluster" {
  backend = "remote"
  config = {
    organization = "raysaini19"
    workspaces = {
      name = "eks-terraform"
    }
  }
}


data "terraform_remote_state" "eks_terraform_cluster_oidc" {
  backend = "remote"
  config = {
    organization = "raysaini19"
    workspaces = {
      name = "eks-irsa"
    }
  }
}

data "aws_eks_cluster" "eks_cluster" {
  name = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

