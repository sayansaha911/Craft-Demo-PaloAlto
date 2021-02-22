
variable "vpc_id" {
  description = ""
  type = string
}

variable "all_subnet_ids" {
  description = "VPC all subnet ids"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type = string
}

variable "ec2_sg_id_for_ssh" {
  description = ""
}

variable "location" {
  description = "The AWS Region in which the resources in this example should exist"
}
