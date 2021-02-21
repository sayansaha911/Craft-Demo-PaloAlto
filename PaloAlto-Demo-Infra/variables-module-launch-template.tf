variable "lt_instance_type" {
  description = "Instance type/size for the Launch Template"
  type        = string
}

variable "eks_ami_id" {
  description = "ID of EKS AMI https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html"
  type        = string
  default     = "ami-0722776b2b19be414"
}

variable "b64_cluster_ca" {
  description = "EKS cluster ca b64 encoded"
  type        = string
  default     = ""
}

variable "api_server_url" {
  description = "EKS cluster api server endpoint url"
  type        = string
  default     = ""
}