#variable "alb_cert_arn" {
#  description = "ARN for certificate to be used for https"
#  type        = string
#}

variable "public_anywhere" {
  description = "Public access"
  default     = "0.0.0.0/0"
}

variable "node_group_asg_name" {
  description = "Name of the autoscaling group"
  default     = ""
}

variable "alb_cluster_sg_id" {
  description = "cluster sg id"
  default     = ""
}