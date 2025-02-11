#main.tf


####################################################################################################
#                              RECOVERING VPC DATA FROM tfstate FILE 
####################################################################################################

data "terraform_remote_state" "l0-vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-state-files-dbj"
    key    = "sensedia/l0-vpc.tfstate"
    region = var.region
  }
}


####################################################################################################
#                                          CLUSTER DATA
####################################################################################################

data "aws_eks_cluster" "my-aws-cluster" { 
  depends_on = [ module.my-cluster ]                                              
  name       = var.eks-cluster-name
}

data "aws_eks_cluster_auth" "my-aws-cluster-auth" {                                                 
  depends_on = [ data.aws_eks_cluster.my-aws-cluster ]                                              
  name       = var.eks-cluster-name
}


####################################################################################################
#                                             CLUSTER 
####################################################################################################
  
module "my-cluster" {
  source          = "app.terraform.io/dbj-hcl/eks/aws"
  version         = "1.0.0"

  name                                = var.eks-cluster-name
  kubernetes-version                  = var.eks-kubernetes-version
  role-flg                            = var.eks-role-flg
  role-name                           = var.eks-role-name

  #####     CLOUDWATCH     #####

  cloudwatch-log-group-flg            = var.eks-cloudwatch-log-group-flg
  cloudwatch-retention-days           = var.eks-cloudwatch-retention-days
  cloudwatch-log-types                = var.eks-cloudwatch-log-types

  public-access-cidrs                 = var.public-access-cidrs
  endpoint-public-access              = var.endpoint-public-access
  endpoint-private-access             = var.endpoint-private-access
  

  ############################################################################################################################################
  #                                                           SUBNET_IDs                                                                     #
  # This is used to know where to created the ENIs (Elastic Network Interfaces) for the EKS nodes to communicate with the EKS control plane. #
  ############################################################################################################################################

  subnet-ids = var.pub-priv-sel == "public" ? flatten(data.terraform_remote_state.l0-vpc.outputs.public_subnets_id) : flatten(data.terraform_remote_state.l0-vpc.outputs.private_subnets_id)
 

  ############################################################################################################################################
  #                                                       SECURITY_GROUP_IDs                                                                #
  # (Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow           #
  # communication between your worker nodes and the Kubernetes control plane.                                                                #
  ############################################################################################################################################

  security-group-ids   = flatten(data.terraform_remote_state.l0-vpc.outputs.security_groups_id)
} 


####################################################################################################
#                                            NODE GROUP 
####################################################################################################
  
module "my-node-group" {
  source          = "app.terraform.io/dbj-hcl/eks-node-group/aws"
  version         = "1.0.0"

  depends_on = [module.my-cluster]

  cluster-name          = var.eks-cluster-name
  node-group-name       = var.node-group-name
  kubernetes-version    = var.eks-kubernetes-version
  role-name             = var.eks-ng-role-name

  scaling-desired-size  = var.scaling-desired-size
  scaling-max-size      = var.scaling-max-size
  scaling-min-size      = var.scaling-min-size

  ami-type              = var.ami-type
  instance-types        = var.instance-types
  capacity-type         = var.capacity-type
  disk-size             = var.disk-size
 
  update-unavailable    = var.update-unavailable


  subnets-id = var.pub-priv-sel == "public" ? flatten(data.terraform_remote_state.l0-vpc.outputs.public_subnets_id) : flatten(data.terraform_remote_state.l0-vpc.outputs.private_subnets_id)   
} 


####################################################################################################
#                               CREATES THE REQUIRED NAMESPACES 
####################################################################################################

module "my-namespaces" {
  source          = "app.terraform.io/dbj-hcl/eks-namespace/aws"
  version         = "1.1.4"
  depends_on      = [module.my-cluster]

  metadata        = var.metadata

}
