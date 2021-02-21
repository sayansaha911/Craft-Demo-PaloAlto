#
# Variables Configuration


variable "cluster_name" {
  type        = string
  description = "specify the EKS cluster name"
}

#variable "eks_version" {
#  description = "EKS cluster K8s version"
#  type = number
#}

variable eks_cluster_sg {
  type = string
  description = "EKS Cluster SG"
}

variable "ssh_key" {
  description = "Name for AWS EC2 SSH key pair"
  type = string
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC to install the cluster in"
}

variable "lt_instance_type" {
  description = "Instance type/size for the Launch Template"
  type        = string
}

variable "b64_cluster_ca" {
  description = "EKS cluster ca b64 encoded"
  type        = string
}

variable "api_server_url" {
  description = "EKS cluster api server endpoint url"
  type        = string
}

variable "asg_desired_size" {
  type = number
  description = "ASG desired number of worker nodes (Shouldn't be less than minimum number)"
}

variable "asg_max_size" {
  type = number
  description = "ASG maximum number of worker nodes"
}

variable "asg_min_size" {
  type = number
  description = "ASG minimum number of worker nodes"
}

variable "private_subnet_ids" {
  type = list(string)
}

#variable "ec2_sg_id_for_ssh" {
#  description = "ec2 security group id from where ssh is permitted"
#}

variable "eks_node_role" {
  description = "EKS Node Role"
}

variable "eks_node_sg_id" {
  description = "EKS Node Security Group Id"
}

variable "eks_node_instance_profile" {
  description = ""
}

