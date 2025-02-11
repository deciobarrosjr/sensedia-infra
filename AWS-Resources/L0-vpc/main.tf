# main.tf
  

####################################################################################################
#                                             VPC and SubNets 
####################################################################################################

module "aws_vpc" {
  source          = "app.terraform.io/dbj-hcl/vpc/aws"
  version         = "1.0.0"

  networking            = var.networking
  security_groups       = var.security_groups

  enable-dns-hostnames  = false
  enable-dns-support    = true
}

