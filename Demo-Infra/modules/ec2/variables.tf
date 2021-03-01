variable "one_public_subnet" {
}

variable "cluster_name" {
    description = "EKS cluster name"
}

variable "vpc_id" {
    description = "vpc id where ec2 security group will be created"
}

variable "ssh_key" {
  description = "Name for AWS EC2 SSH key pair"
  type = string
}