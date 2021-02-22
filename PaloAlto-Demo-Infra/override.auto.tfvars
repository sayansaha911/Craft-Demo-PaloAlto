location = "us-east-1"
#vpc_id             = module.networking.vpc_id
#private_subnet_ids = [module.networking.public_subnet_id, module.networking.private_subnet_aza, module.networking.private_subnet_azb, module.networking.private_subnet_azc]
#public_subnet_ids  = module.networking.public_subnet_id
#all_subnet_ids     = [module.networking.public_subnet_id, module.networking.private_subnet_aza, module.networking.private_subnet_azb, module.networking.private_subnet_azc]
ssh_key_name = "eks-demo-key"

#
# module: ssh-keypair
#

#
# module: launch-template
#

lt_instance_type = "t3.large"

#
# module: rds-postgres
#

#rds_name              = "pgdb-demo"
#rds_db_size           = "db.m4.xlarge"
#rds_username          = "postgres"
#rds_subnet_group_name = "pgdb-demo-subnet-group"
#rds_storage_type      = "gp2"
#rds_allocated_storage = 100
#rds_multi_az          = false

#
# module: eks
#

cluster_name = "PaloAlto-Craft-Demo"
#eks_version      = "1.18.9"
public_anywhere = "0.0.0.0/0"
#alb_cert_arn     = ""
asg_desired_size = 2
asg_max_size     = 5
asg_min_size     = 2