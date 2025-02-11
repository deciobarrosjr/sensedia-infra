# terraform.tfvars

####################################################################################################
#                                        ALB Variables
####################################################################################################

alb-controller-name             = "aws-load-balancer-controller"
alb-controller-repository       = "https://aws.github.io/eks-charts"
alb-controller-chart            = "aws-load-balancer-controller"

alb-controller-version          = "1.8.1"
alb-controller-namespace        = "alb-controller"
alb-controller-create-namespace = false
