############ GLOBAL ###################

variable "vpc_id" {
  description = ""
  type = string
}

#variable "private_subnet_ids" {
#  description = "VPC private subnet ids"
#  type        = list(string)
#}

#variable "public_subnet_ids" {
#  description = "VPC public subnet ids"
#  type        = list(string)
#}

variable "all_subnet_ids" {
  description = "VPC all subnet ids"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type = string
}

#variable "eks_node_sg_id" {
#  description = "EKS Node Security Group Id"
#}

variable "ec2_sg_id_for_ssh" {
  description = ""
}

#variable "eks_node_role" {
#  description = "EKS Node Role"
#}