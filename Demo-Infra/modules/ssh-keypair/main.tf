resource "aws_key_pair" "eks-ng-key" {
  key_name   = var.ssh_key_name

  public_key = var.ssh_key_data
}