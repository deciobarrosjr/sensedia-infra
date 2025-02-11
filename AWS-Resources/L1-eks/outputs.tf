# outputs.tf 


output "eks-name" {
  value = module.my-cluster.eks-name
}

output "node-group-role-name" {
  value = module.my-node-group.node-group-role-name
}

output "identity-oidc-issuer" {
  value = module.my-cluster.eks-cluster-oidc-issuer
}