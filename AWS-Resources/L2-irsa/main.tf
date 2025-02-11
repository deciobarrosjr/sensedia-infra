# main.tf


####################################################################################################
#                Creates the OIDC Provider and associate it with an existing EKS Cluster
####################################################################################################

module "iam-oidc-on-aws" {
  source  = "app.terraform.io/dbj-hcl/iam-oidc-on-aws/aws"
  version = "1.0.0"

  cluster-name           = var.cluster-name
  iam-oidc-name          = var.iam-oidc-name
  iam-oidc-client-id     = var.iam-oidc-client-id  
}


####################################################################################################
#                               Creates IRSA for THE ALB CONTROLLER
####################################################################################################

module "iam-oidc-alb-irsa" {
  source  = "app.terraform.io/dbj-hcl/iam-oidc-irsa/aws"
  version = "1.0.0"

  cluster-name            = var.cluster-name

  irsa-policy-name        = var.irsa-alb-policy-name
  irsa-policy-description = var.irsa-alb-policy-description
  file-policy-flg         = var.file-policy-flg
  file-policy-name        = var.file-policy-name
  irsa-policy             = {}

  irsa-role-name          = var.irsa-alb-role-name
  irsa-service-account    = var.irsa-alb-service-account
  irsa-namespace          = var.irsa-alb-namespace
}


####################################################################################################
#                   Creates IRSA for the application that will be running on the PODs
#
# The only required AWS services for this HelloWorld application is to pull the hell chart from 
#  ECR to install on the cluster using helm_release.
####################################################################################################

module "iam-oidc-apl-irsa" {
  source  = "app.terraform.io/dbj-hcl/iam-oidc-irsa/aws"
  version = "1.0.0"

  cluster-name            = var.cluster-name

  irsa-policy-name        = var.irsa-apl-policy-name
  irsa-policy-description = var.irsa-apl-policy-description
  file-policy-flg         = var.irsa-apl-file-policy-flg
  irsa-policy             = var.irsa-apl-policy

  irsa-role-name          = var.irsa-apl-role-name
  irsa-service-account    = var.irsa-apl-service-account
  irsa-namespace          = var.irsa-apl-namespace
}
