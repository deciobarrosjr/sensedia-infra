# terraform.tfvars 

#####     CREATING THE OIDC Identity Provider FOR THE EKS CLUSTER     #####

cluster-name            = "my-eks"
iam-oidc-name           = "my-oidc-name"
iam-oidc-client-id      = "kubernetes"


###############################################################################################################################
#                                                       AWS ALB IRSA                                                          #
###############################################################################################################################

irsa-alb-policy-name        = "my-alb-policy-name"
irsa-alb-policy-description = "ALB policy for pod SA alb-controller/my-alb-sa"
irsa-alb-role-name          = "my-alb-role-name"
irsa-alb-service-account    = "my-alb-sa"
irsa-alb-namespace          = "alb-controller"
file-policy-flg             = true
file-policy-name            = "./policy/AmazonEKSLoadBalancerControllerPolicy.json"


###############################################################################################################################
#                                                       AWS APL IRSA                                                          #
###############################################################################################################################

irsa-apl-policy-name        = "my-apl-policy-name"
irsa-apl-policy-description = "Hello World APL policy for pod SA default/my-apl-sa"
irsa-apl-role-name          = "my-apl-role-name"
irsa-apl-service-account    = "my-apl-sa"
irsa-apl-namespace          = "default"
irsa-apl-file-policy-flg    = false

irsa-apl-policy = {
  "statment1" = {
    irsa-effect     = "Allow"
    irsa-resources  = ["*"]
    irsa-actions    = [
                        "ecr:GetDownloadUrlForLayer",
                        "ecr:BatchCheckLayerAvailability",
                        "ecr:GetAuthorizationToken",
                        "ecr:DescribeRepositories",
                        "ecr:ListImages"
          ]
    }
}