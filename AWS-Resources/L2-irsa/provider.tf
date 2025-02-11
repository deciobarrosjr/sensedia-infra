terraform {

  backend "s3" {
    bucket = "terraform-state-files-dbj"
    key    = "sensedia/l2-irsa.tfstate"
    region = "sa-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.55"
    } 
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }           
  }
}


provider "aws" {
  region = var.region
}