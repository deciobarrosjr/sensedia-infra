####################################################################################################
#                                 RECOVERING REMOTE STATE DATA
####################################################################################################

data "terraform_remote_state" "l1-eks" {
  backend = "s3"

  config = {
    bucket = "terraform-state-files-dbj"
    key    = "sensedia/l1-eks.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "l2-irsa" {
  backend = "s3"

  config = {
    bucket = "terraform-state-files-dbj"
    key    = "sensedia/l2-irsa.tfstate"
    region = var.region
  }
}


data "aws_eks_cluster" "my-aws-cluster" { 
  depends_on = [ data.terraform_remote_state.l1-eks ]                                              
  name       = data.terraform_remote_state.l1-eks.outputs.eks-name
}

data "aws_eks_cluster_auth" "my-aws-cluster-auth" {                                                 
  depends_on = [ data.aws_eks_cluster.my-aws-cluster ]                                              
  name       = data.terraform_remote_state.l1-eks.outputs.eks-name
}


####################################################################################################
#                                 DELAY FOR THE IRSA TO BE CREATED

####################################################################################################

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 300"  # Adjust the time in seconds as needed
  }
}


####################################################################################################
#                                 INSTALLING AWS ALB CONTROLLER 
####################################################################################################

resource "helm_release" "my-alb-controller" {

  depends_on = [ data.terraform_remote_state.l2-irsa, data.terraform_remote_state.l1-eks, null_resource.delay ]

  name              = var.alb-controller-name
  repository        = var.alb-controller-repository
  chart             = var.alb-controller-chart
  version           = var.alb-controller-version
  namespace         = var.alb-controller-namespace
  create_namespace  = var.alb-controller-create-namespace 

  set {
    name  = "clusterName"
    type  = "string"    
    value = "${data.terraform_remote_state.l1-eks.outputs.eks-name}"
  }
  set {
    name  = "serviceAccount.create"
    type  = "auto"
    value = false
  }  
  set {
    name  = "serviceAccount.name"
    type  = "string"    
    value = "${data.terraform_remote_state.l2-irsa.outputs.alb-sa-name}"
  }  
}
