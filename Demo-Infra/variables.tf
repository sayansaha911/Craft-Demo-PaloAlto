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

variable "ssh_key_name" {
  description = "Name for AWS EC2 SSH key pair"
  type        = string
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}



# ALB Module Variables

variable "public_anywhere" {
  description = "Public access"
}


# Self Managed Node Group Module variables

variable "asg_desired_size" {
  type        = number
  description = "ASG desired number of worker nodes (Shouldn't be less than minimum number)"
}

variable "asg_max_size" {
  type        = number
  description = "ASG maximum number of worker nodes"
}

variable "asg_min_size" {
  type        = number
  description = "ASG minimum number of worker nodes"
}

variable "lt_instance_type" {
  description = "Instance type/size for the Launch Template"
  type        = string
}

variable "eks_ami_id" {
  description = "ID of EKS AMI https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html"
  type        = string
}


# SSH Key pai module variable

variable "ssh_key_data" {
  description = "Public key for the AWS EC2 SSH key pair"
  type        = string
}