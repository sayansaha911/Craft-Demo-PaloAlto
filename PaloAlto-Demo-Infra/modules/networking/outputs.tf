# Defining outputs
# Output of VPC Id
output vpc_id {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.primary.*.id, [""])[0]
}

# Output of Subnet Ids
output public_subnet_aza {
  description = "The ID of each Public Subnet"
  value       = aws_subnet.public_subnet[0].id
}
output public_subnet_azb {
  description = "The ID of each Public Subnet"
  value       = aws_subnet.public_subnet[1].id
}

output private_subnet_aza {
  description = "The ID of Private Subnet A"
  value       = aws_subnet.private_subnet_az[0].id
}
output private_subnet_azb {
  description = "The ID of Private Subnet B"
  value       = aws_subnet.private_subnet_az[1].id
}