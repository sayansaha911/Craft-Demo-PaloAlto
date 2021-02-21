#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EC2 Security Group to allow networking traffic
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances
#

#resource "aws_iam_role" "eks-node" {
#  name = "${var.cluster_name}-node-role"

#  assume_role_policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#POLICY

#}

#resource "aws_iam_role_policy" "cluster-autoscaler-policy" {
#  name = "cluster-autoscaler"
#  role = aws_iam_role.eks-node.name

#  policy = <<-EOF
#  {
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Action": [
#          "autoscaling:DescribeAutoScalingGroups",
#          "autoscaling:DescribeAutoScalingInstances",
#          "autoscaling:DescribeLaunchConfigurations",
#          "autoscaling:DescribeTags",
#          "autoscaling:SetDesiredCapacity",
#          "autoscaling:TerminateInstanceInAutoScalingGroup",
#          "ec2:DescribeLaunchTemplateVersions"
#        ],
#        "Effect": "Allow",
#        "Resource": "*"
#      }
#    ]
#  }
#  EOF
#}
#resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.eks-node.name
#}


#resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.eks-node.name
#}

#resource "aws_iam_role_policy_attachment" "node-AWSKeyManagementServicePowerUser" {
#  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
#  role       = aws_iam_role.eks-node.name
#}

#resource "aws_iam_role_policy_attachment" "node-AmazonSSMFullAccess" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
#  role       = aws_iam_role.eks-node.name
#}

#resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.eks-node.name
#}

#resource "aws_iam_instance_profile" "eks-node" {
#  name = "${var.cluster_name}-node-instance-profile"
#  role = var.eks_node_role
#}

#resource "aws_security_group" "eks-node" {
#  name        = "${var.cluster_name}-node-sg"
#  description = "Security group for all nodes in the cluster"
#  vpc_id      = var.vpc_id

#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  tags = {
#    "Name"                                      = "${var.cluster_name}-node-sg"
#    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#  }
#}

#resource "aws_security_group_rule" "eks-node-ingress-self" {
#  description              = "Allow node to communicate with each other"
#  from_port                = 0
#  protocol                 = "-1"
#  security_group_id        = aws_security_group.eks-node.id
#  source_security_group_id = aws_security_group.eks-node.id
#  to_port                  = 65535
#  type                     = "ingress"
#}

#resource "aws_security_group_rule" "eks-node-ingress-cluster" {
#  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#  from_port                = 1025
#  protocol                 = "tcp"
#  security_group_id        = aws_security_group.eks-node.id
#  source_security_group_id = var.eks_cluster_sg
#  to_port                  = 65535
#  type                     = "ingress"
#}

#resource "aws_security_group_rule" "eks-node-ingress-cluster-https" {
#  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#  from_port                = 443
#  protocol                 = "tcp"
#  security_group_id        = aws_security_group.eks-node.id
#  source_security_group_id = var.eks_cluster_sg
#  to_port                  = 443
#  type                     = "ingress"
#}

#resource "aws_security_group_rule" "eks-node-ingress-ssh" {
#  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#  from_port                = 22
#  protocol                 = "tcp"
#  security_group_id        = aws_security_group.eks-node.id
#  source_security_group_id = var.ec2_sg_id_for_ssh
#  to_port                  = 22
#  type                     = "ingress"
#}

#data "aws_ami" "eks-worker" {
#  filter {
#    name   = "name"
#    values = ["ubuntu-eks/k8s_${var.eks_version}/*"]
#  }

#  most_recent = true
#  owners      = ["602401143452"] #Amazon EKS AMI Account ID
#}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster_name} --b64-cluster-ca ${var.b64_cluster_ca} --apiserver-endpoint ${var.api_server_url} > /tmp/eks.log
USERDATA
}

#resource "aws_launch_configuration" "eks" {
#  associate_public_ip_address = false
#  iam_instance_profile        = aws_iam_instance_profile.eks-node.name
#  image_id                    = "ami-08a602b0877a97d07"
#  instance_type               = var.lt_instance_type
#  name_prefix                 = "${var.cluster_name}-"
#  key_name = var.ssh_key
#  security_groups             = [aws_security_group.eks-node.id]
#  user_data_base64            = base64encode(local.eks-node-userdata)

#  lifecycle {
#    create_before_destroy = true
#  }
#}


resource "aws_launch_template" "eks-ng-lt" {
  name          = "${var.cluster_name}-launch-template"
  instance_type = var.lt_instance_type
  key_name      = var.ssh_key
  user_data     = base64encode(local.eks-node-userdata)
  image_id      = "ami-04fd70f2aa0a10192"
  vpc_security_group_ids             = [var.eks_node_sg_id]
  iam_instance_profile {
    name = var.eks_node_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 40
    }
  }
}

resource "aws_autoscaling_group" "eks-asg" {
  name                 = "${var.cluster_name}-asg"
  #launch_configuration = aws_launch_configuration.eks.id
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_size
  vpc_zone_identifier  = var.private_subnet_ids
  
  launch_template {
    id      = aws_launch_template.eks-ng-lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
}

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = ""
    propagate_at_launch = true
}

}

