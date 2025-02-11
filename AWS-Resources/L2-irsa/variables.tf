# variables.tf 

variable "region" {
  type        = string
  description = "The default region to create the resources."
}

variable "cluster-name" {
  type        = string
  description = "The cluster name where the Jenkins should be installed."
}

variable "iam-oidc-name" {
    type    = string
    description = "The OIDC Identity Provider name"
}

variable "iam-oidc-client-id" {
    type    = string
    description = "The client ID for the OIDC Identity Provider."
}

#####     ALB IRSA VARIABLES     #####

variable "irsa-alb-policy-name" {
  type        = string
  description = "The name of the IRSA ALB policy."
}

variable "irsa-alb-policy-description" {
  type        = string
  description = "The description of the IRSA ALB policy."
}

variable "irsa-alb-role-name" {
  type        = string
  description = "The name of the IRSA ALB role."
}

variable "irsa-alb-service-account" {
  type        = string
  description = "The name of the IRSA ALB service account."
}

variable "irsa-alb-namespace" {
  type        = string
  description = "The namespace where the IRSA ALB service account will be created."
}

variable "file-policy-flg" {
    type    = bool
    default = false
    description = "Flag to indicate if the policy will be created using a JSON file or a variable."
}

variable "file-policy-name" {
    type        = string
    default     = null
    description = "The Full Name (Path/Name) of the JSON file containing the policy."
}


#####     APL IRSA VARIABLES     #####

variable "irsa-apl-policy-name" {
  type        = string
  description = "The name of the IRSA HelloWorld application policy."
}

variable "irsa-apl-policy-description" {
  type        = string
  description = "The description of the IRSA HelloWorld application policy."
}

variable "irsa-apl-role-name" {
  type        = string
  description = "The name of the IRSA HelloWorld application role."
}

variable "irsa-apl-service-account" {
  type        = string
  description = "The name of the IRSA HelloWorld application service account."
}

variable "irsa-apl-namespace" {
  type        = string
  description = "The namespace where the IRSA HelloWorld application service account will be created."
}

variable "irsa-apl-file-policy-flg" {
    type    = bool
    default = false
    description = "Flag to indicate if the policy will be created using a JSON file or a variable."
}

variable "irsa-apl-policy" {
  type = map(object({
    irsa-effect     = string
    irsa-resources  = list(string)
    irsa-actions    = list(string)
  }))
} 