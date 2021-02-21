################## modules ###################################################################

#
# EKS Cluster and ALB
#

locals {
  all_subnet_ids     = [module.networking.public_subnet_aza, module.networking.public_subnet_azb, module.networking.private_subnet_aza, module.networking.private_subnet_azb]
  private_subnet_ids = [module.networking.private_subnet_aza, module.networking.private_subnet_azb]
  public_subnet_ids  = [module.networking.public_subnet_aza, module.networking.public_subnet_azb]
}

module networking {
  source = "./modules/networking"

  #vpc_cidr                = var.vpc_cidr
  #public_subnet_cidr      = var.public_subnet_cidr

  #private_subnet_aza_cidr = var.private_subnet_aza_cidr
  #private_subnet_azb_cidr = var.private_subnet_azb_cidr
  #private_subnet_azc_cidr = var.private_subnet_azc_cidr
}

module "eks" {
  source = "./modules/eks"

  vpc_id = module.networking.vpc_id
  #private_subnet_ids = var.private_subnet_ids
  #public_subnet_ids  = var.public_subnet_ids
  all_subnet_ids = local.all_subnet_ids
  cluster_name   = var.cluster_name
  #eks_node_sg_id = module.self-managed-node-group.eks_node_sg_id
  #eks_node_role = module.self-managed-node-group.eks_node_role
  ec2_sg_id_for_ssh = module.ec2.ec2_sg_id_for_ssh

   
}

#
# SSH Key Pair
#

module "ssh-keypair" {
  source = "./modules/ssh-keypair"

  cluster_name = var.cluster_name
  ssh_key_data = var.ssh_key_data
  ssh_key_name = var.ssh_key_name
}

#
# Node Group Launch Template
#

module "self-managed-node-group" {
  source = "./modules/self-managed-node-group"

  eks_cluster_sg   = module.eks.cluster_security_group_id
  cluster_name     = var.cluster_name
  ssh_key     = module.ssh-keypair.ssh_key
  vpc_id           = module.networking.vpc_id
  lt_instance_type = var.lt_instance_type
  b64_cluster_ca   = module.eks.cluster_certificate_authority_data
  api_server_url   = module.eks.cluster_api_server_url
  #eks_version        = var.eks_version
  asg_desired_size   = var.asg_desired_size
  asg_max_size       = var.asg_max_size
  asg_min_size       = var.asg_min_size
  private_subnet_ids = local.private_subnet_ids
  #ec2_sg_id_for_ssh = module.ec2.ec2_sg_id_for_ssh
  eks_node_role = module.eks.eks_node_role
  eks_node_sg_id = module.eks.eks_node_sg_id
  eks_node_instance_profile = module.eks.eks_node_instance_profile

  depends_on = [
    module.eks.eks_cluster_id
  ]
}

#module "launch-template" {
#  source           = "./modules/launch-template"

#  lt_instance_type = var.lt_instance_type
#  ssh_key_name     = var.ssh_key_name
#  eks_ami_id       = var.eks_ami_id
#  cluster_name     = var.cluster_name
#  b64_cluster_ca   = module.eks.cluster_certificate_authority_data
#  api_server_url   = module.eks.cluster_api_server_url
#}

#
# ASG
#

#module "node-group" {
#  source = "./modules/node-group"

#  vpc_id             = var.vpc_id
#  private_subnet_ids = var.private_subnet_ids
#  public_subnet_ids  = var.public_subnet_ids
#  all_subnet_ids     = var.all_subnet_ids

#  cluster_name     = var.cluster_name
#  asg_desired_size = var.asg_desired_size
#  asg_max_size     = var.asg_max_size
#  asg_min_size      = var.asg_min_size

#}

#
# ALB
#

module "alb" {
  source = "./modules/alb"

  vpc_id = module.networking.vpc_id
  #private_subnet_ids = local.private_subnet_ids
  public_subnet_ids = local.public_subnet_ids
  #all_subnet_ids     = local.all_subnet_ids
  cluster_name = var.cluster_name

  #alb_cert_arn    = var.alb_cert_arn
  public_anywhere = var.public_anywhere
  asg_name        = module.self-managed-node-group.asg_name
  eks_node_sg_id  = module.eks.eks_node_sg_id

}

module "ec2" {
  source = "./modules/ec2"

  one_public_subnet = module.networking.public_subnet_aza
  cluster_name = var.cluster_name
  vpc_id = module.networking.vpc_id
  ssh_key = module.ssh-keypair.ssh_key

}