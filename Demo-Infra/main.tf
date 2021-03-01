
# Defining local variables from networking module

locals {
  all_subnet_ids     = [module.networking.public_subnet_aza, module.networking.public_subnet_azb, module.networking.private_subnet_aza, module.networking.private_subnet_azb]
  private_subnet_ids = [module.networking.private_subnet_aza, module.networking.private_subnet_azb]
  public_subnet_ids  = [module.networking.public_subnet_aza, module.networking.public_subnet_azb]
}


# Invoking networking module

module "networking" {
  source = "./modules/networking"

}

# Invoking eks module

module "eks" {
  source = "./modules/eks"

  vpc_id            = module.networking.vpc_id
  all_subnet_ids    = local.all_subnet_ids
  cluster_name      = var.cluster_name
  ec2_sg_id_for_ssh = module.ec2.ec2_sg_id_for_ssh
  location          = var.location

}


# Invoking SSH Key Pair module

module "ssh-keypair" {
  source = "./modules/ssh-keypair"

  cluster_name = var.cluster_name
  ssh_key_data = var.ssh_key_data
  ssh_key_name = var.ssh_key_name
}

# Invoking self managed node group module

module "self-managed-node-group" {
  source = "./modules/self-managed-node-group"

  eks_cluster_sg            = module.eks.cluster_security_group_id
  cluster_name              = var.cluster_name
  ssh_key                   = module.ssh-keypair.ssh_key
  eks_ami_id                = var.eks_ami_id
  vpc_id                    = module.networking.vpc_id
  lt_instance_type          = var.lt_instance_type
  b64_cluster_ca            = module.eks.cluster_certificate_authority_data
  api_server_url            = module.eks.cluster_api_server_url
  asg_desired_size          = var.asg_desired_size
  asg_max_size              = var.asg_max_size
  asg_min_size              = var.asg_min_size
  private_subnet_ids        = local.private_subnet_ids
  eks_node_role             = module.eks.eks_node_role
  eks_node_sg_id            = module.eks.eks_node_sg_id
  eks_node_instance_profile = module.eks.eks_node_instance_profile

  depends_on = [
    module.eks.eks_cluster_id
  ]
}


# Invoking ALB module

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = local.public_subnet_ids
  cluster_name      = var.cluster_name

  public_anywhere = var.public_anywhere
  asg_name        = module.self-managed-node-group.asg_name
  eks_node_sg_id  = module.eks.eks_node_sg_id

}

# Invoking EC2 Bastion Instance module

module "ec2" {
  source = "./modules/ec2"

  one_public_subnet = module.networking.public_subnet_aza
  cluster_name      = var.cluster_name
  vpc_id            = module.networking.vpc_id
  ssh_key           = module.ssh-keypair.ssh_key

}