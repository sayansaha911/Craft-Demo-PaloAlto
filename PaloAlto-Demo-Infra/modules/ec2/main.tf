data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ec2" {
  name        = "${var.cluster_name}-ec2-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-ec2-sg"
  }
}

resource "aws_security_group_rule" "ec2-ssh" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2.id
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_network_interface" "foo" {
  subnet_id   = var.one_public_subnet
  security_groups = [aws_security_group.ec2.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "bastion-host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  key_name = var.ssh_key

  tags = {
    Name = "${var.cluster_name}-bastion-ec2"
  }
}

