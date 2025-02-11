# variables.tf

variable "region" {
  type        = string
  description = "The default region to create the resources."
}


####################################################################################################
#     Defines if the Cluster and Node Group will be created on Private or Public Subnets           #
####################################################################################################

variable "pub-priv-sel" {
  type        = string
  description = "Defines if the Cluster and Node Group will be created on Private or Public Subnets"
  default     = "public"
}


####################################################################################################
#                                       CLUSTER VARIABLES                                          #
####################################################################################################

variable "eks-cluster-name" {
  type        = string
  description = "The cluster name where the Jenkins should be installed."
}

variable "eks-kubernetes-version" {
  type        = string
  description = "The Kubernetes version to be used on the nodes."
}

variable eks-role-flg {
  type = bool
  description = "Creates or use the role-name specified."
}

variable "eks-role-name" {
  type        = string
  description = "The role name to be created to be used by the cluster."
}

variable "eks-cloudwatch-log-group-flg" {
  type        = bool
  description =  "Creates a CloudWatch group with the same name as the cluster."
}

variable "eks-cloudwatch-retention-days" {
  type        = number
  description =  "The maximun days to keep the log available."
}

variable "eks-cloudwatch-log-types" {
  type        = list(string)
  description = "Amazon EKS control plane logging."
}

variable "public-access-cidrs" {
  type        = list(string)
  description = "The CIDR blocks allowed to access the EKS cluster publicly."
  default     = ["0.0.0.0/0"]
}

variable "endpoint-public-access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  default     = true
}

variable "endpoint-private-access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
  default     = false
}


#####     NODE GROUP     #####

variable "node-group-name" {
  type        = string
  description = "The EKS Node Group name."
}

variable "scaling-desired-size" {
  type        = number
  description = "Desired number of worker nodes."
}

variable "scaling-max-size" {
  type        = number
  description = "Maximum number of worker nodes."
}

variable "scaling-min-size" {
  type        = number
  description = "Minimum number of worker nodes."
}

variable "update-unavailable" {
  type        = number
  description = "Desired max number of unavailable worker nodes during node group update."
}

variable "eks-ng-role-name" {
  type        = string
  description = "The role name to be created to be used by the Node Group."
}

variable "ami-type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group."
}

variable "instance-types" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node Group."
}

variable "capacity-type" {
  type        = string
  description = "Type of capacity associated with the EKS Node Group."
}

variable "disk-size" {
  type        = string
  description = "Disk size in GiB for worker nodes."
}


#####     NAMESPACES     #####

variable "metadata" {
  type = map(object({
    name        = string
    labels      = optional(map(string))
    annotations = optional(map(string))
  }))
}  