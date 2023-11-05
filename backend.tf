terraform {
  cloud {
    organization = "raysaini19"

    workspaces {
      name = "eks-resource"
    }
  }
}