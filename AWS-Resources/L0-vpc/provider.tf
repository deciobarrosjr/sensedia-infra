terraform {

  backend "local" {
    path = "../tfstate/l0-vpc.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "=5.55.0"
    } 
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.31.0"
    } 
  }
}

provider "aws" {
  region = var.region
}