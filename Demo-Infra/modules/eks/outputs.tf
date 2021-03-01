#
# Outputs
#

locals {
  
kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
KUBECONFIG

}


output "kubeconfig" {
  value = local.kubeconfig
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = aws_security_group.eks-cluster.id
}

output "alb_cluster_sg_id" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_api_server_url" {
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_node_role" {
  value = aws_iam_role.eks-node.arn
}

output "eks_node_sg_id" {
  value = aws_security_group.eks-node.id
}

output "eks_node_instance_profile" {
  value = aws_iam_instance_profile.eks-node.name
}
