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