# terraform.tfvars



####################################################################################################
#     Defines if the Cluster and Node Group will be created on Private or Public Subnets           #
####################################################################################################

pub-priv-sel = "private"


####################################################################################################
#                                            Cluster Variables
####################################################################################################

eks-cluster-name                        = "my-eks"
eks-kubernetes-version                  = "1.30"
eks-role-flg                            = true
eks-role-name                           = "my-eks-role"

eks-cloudwatch-log-group-flg            = true
eks-cloudwatch-retention-days           = 7
eks-cloudwatch-log-types                = ["api", "audit"]

public-access-cidrs                     = ["0.0.0.0/0"]
endpoint-public-access                  = true
endpoint-private-access                 = false



####################################################################################################
#                                         Namespaces
####################################################################################################

metadata = {
  "metadata1" = {
    name            = "alb-controller"  
  }  
}


####################################################################################################
#                                          Node Group Variables
####################################################################################################

node-group-name         = "my-eks-ng"
eks-ng-role-name        = "my-eks-ng-role" 

scaling-desired-size   = 1
scaling-max-size       = 2
scaling-min-size       = 1
update-unavailable     = 1

ami-type               = "AL2_x86_64"
instance-types         = ["t3.medium"]
capacity-type          = "ON_DEMAND"
disk-size              = 50
