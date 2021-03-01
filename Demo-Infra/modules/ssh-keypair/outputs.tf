output "ssh_key" {
  value       = aws_key_pair.eks-ng-key.id
  description = "name of the generated ssh key"
}
