# GLOBAL variables

variable "location" {
  description = "The AWS Region in which the resources in this example should exist"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "AWS account user access key"
}

variable "secret_key" {
  type        = string
  description = "AWS account user secret key"
}

#variable "vpc_id" {
#  description = "The Prefix used for all resources in this example"
#  type        = string
#}

#variable "private_subnet_ids" {
#  description = "VPC private subnet ids"
#  type        = list(string)
#}

#variable "public_subnet_ids" {
#  description = "VPC public subnet ids"
#  type        = list(string)
#}

#variable "all_subnet_ids" {
#  description = "VPC all subnet ids"
#  type        = list(string)
#}

variable "ssh_key_name" {
  description = "Name for AWS EC2 SSH key pair"
  type        = string
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

#variable "eks_version" {
#  description = "EKS cluster K8s version"
#}