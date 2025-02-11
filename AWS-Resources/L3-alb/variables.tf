##### variables.tf

variable "region" {
  type        = string
  description = "The default region to create the resources."
}


####################################################################################################
#                                ALB CONTROLLER Variables
####################################################################################################

variable "alb-controller-name" {
  description = "The name of the AWS Load Balancer controller"
  type        = string
}

variable "alb-controller-repository" {
  description = "The repository URL for the AWS Load Balancer controller chart"
  type        = string
}

variable "alb-controller-chart" {
  description = "The chart name for the AWS Load Balancer controller"
  type        = string
}

variable "alb-controller-version" {
  type        = string
  description = "The ALB Charte Version."
}

variable "alb-controller-namespace" {
  type        = string
  description = "The ALNN Namespace."
}

variable "alb-controller-create-namespace" {
  type        = bool
  description = "The ALB Create Namespace flag."
}
