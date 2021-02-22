#
# EKS Worker Nodes Resources
#  * AutoScaling Launch Template to configure worker instances
#  * AutoScaling Group to launch worker instances
#



# Configuring userdata
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster_name} --b64-cluster-ca ${var.b64_cluster_ca} --apiserver-endpoint ${var.api_server_url} > /tmp/eks.log
USERDATA
}

# Creating Launch Templare with Userdata
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

# Creating ASG
resource "aws_autoscaling_group" "eks-asg" {
  name                 = "${var.cluster_name}-asg"
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

