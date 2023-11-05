# Reference: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1
# Resource: Kubernetes Job
resource "kubernetes_job_v1" "irsa-s3" {
  metadata {
    name = "irsa-s3"
  }
  spec {
    template {
      metadata {
        labels = {
          app = "irsa-s3"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.eks_cluster_irsa_sa.metadata.0.name
        container {
          name  = "irsa-s3"
          image = "amazon/aws-cli:latest"
          args  = ["s3", "ls"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true
}