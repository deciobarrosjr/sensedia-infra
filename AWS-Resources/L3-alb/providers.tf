terraform {

  backend "s3" {
    bucket = "terraform-state-files-dbj"
    key    = "sensedia/l3-deploy-alb.tfstate"
    region = "sa-east-1"
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.55"
    } 
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }  
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }           
  }
}


provider "aws" {
  region     = var.region
}

#   KUBERNETES PROVIDER

provider "kubernetes" {
  host                      = data.aws_eks_cluster.my-aws-cluster.endpoint
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.my-aws-cluster.certificate_authority.0.data)
  token                     = data.aws_eks_cluster_auth.my-aws-cluster-auth.token
}

# HELM PROVIDER

provider "helm" {
  kubernetes {
  host                      = data.aws_eks_cluster.my-aws-cluster.endpoint
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.my-aws-cluster.certificate_authority.0.data)
  token                     = data.aws_eks_cluster_auth.my-aws-cluster-auth.token
  }
}