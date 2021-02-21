output ec2_sg_id_for_ssh {
    value = aws_security_group.ec2.id
}