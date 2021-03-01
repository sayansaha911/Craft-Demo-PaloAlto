variable "cluster_name" {
  description = "The Prefix used for all resources in this example"
}

variable "ssh_key_name" {
  description = "Name for AWS EC2 SSH key pair"
  type = string
}

variable "ssh_key_data" {
  description = "Public key for the AWS EC2 SSH key pair"
  type        = string
}