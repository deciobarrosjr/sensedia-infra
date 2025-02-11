# outputs

output "alb-role-arn" {
  value = module.iam-oidc-alb-irsa.role-arn
}

output "alb-role-name" {
  value = var.irsa-alb-role-name
}

output "alb-sa-name" {
  value = var.irsa-alb-service-account
}
