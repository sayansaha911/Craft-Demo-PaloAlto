output "kubeconfig" {
  sensitive = true
  value     = module.eks.kubeconfig
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Output ALB DNS Hostname"
}


