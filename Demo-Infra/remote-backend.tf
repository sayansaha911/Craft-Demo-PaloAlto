terraform {
  backend "s3" {
    bucket = "sayan2020"
    key    = "Terraform Backend/"
    region = "ap-south-1"
  }
}