#
# Outputs
#

output "asg_name" {
  value = aws_autoscaling_group.eks-asg.name
}

#output "eks_node_sg_id" {
#  value = aws_security_group.eks-node.id
#}

#output "eks_node_role" {
#  value = aws_iam_role.eks-node.arn
#}