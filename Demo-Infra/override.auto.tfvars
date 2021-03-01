# global variables

location        = "us-east-1"
cluster_name    = "PaloAlto-Craft-Demo"
public_anywhere = "0.0.0.0/0"


# module: ssh-keypair

ssh_key_name = "eks-demo-key"


# module: eks and self managed node group

lt_instance_type = "t3.large"
asg_desired_size = 2
asg_max_size     = 5
asg_min_size     = 2
eks_ami_id       = "ami-04fd70f2aa0a10192"