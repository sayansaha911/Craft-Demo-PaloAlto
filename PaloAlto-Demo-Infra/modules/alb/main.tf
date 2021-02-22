#
# Resources Created
#  * IAM Role to allow EKS to manage other AWS services
#  * IAM Role to allow EC2 to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster and worker nodes
#  * Create EKS Cluster and Install other dependencies
#

# Creating ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "${var.cluster_name}-alb-sg"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.cluster_name}-alb-sg"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_anywhere]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_anywhere]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_anywhere]
  }
}

resource "aws_security_group_rule" "allow_all_from_alb_in_cluster_sg" {
  type                     = "ingress"
  from_port                = 30080
  to_port                  = 30080
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = var.eks_node_sg_id
}

#Creating ALB Target Groups and Listeners
resource "aws_alb" "ingress-alb" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "${var.cluster_name}-alb"
  }
}

resource "aws_alb_target_group" "ingress-tg" {
  name     = "${var.cluster_name}-ingress-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener" "alb-ingress-listener" {
  load_balancer_arn = aws_alb.ingress-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ingress-tg.arn
  #  redirect {
  #    port        = "443"
  #    protocol    = "HTTPS"
  #    status_code = "HTTP_301"
  #  }
  }
}

#To configure SSL
#resource "aws_alb_listener" "alb-ingress-listener-ssl" {
#  load_balancer_arn = aws_alb.ingress-alb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
#  certificate_arn   = var.alb_cert_arn
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_alb_target_group.ingress-tg.arn
#  }
#}

# Attaching ALB to ASG
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.asg_name
  alb_target_group_arn   = aws_alb_target_group.ingress-tg.arn
}