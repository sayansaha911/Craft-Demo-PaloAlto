#Output ALB DNS Hostname
output alb_dns_name {
  value       = aws_alb.ingress-alb.dns_name
  description = "Output ALB DNS Hostname"
}
