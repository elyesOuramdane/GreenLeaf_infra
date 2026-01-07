output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "subnet_private_ids" {
  value = aws_subnet.private[*].id
}

output "subnet_data_ids" {
  value = aws_subnet.data[*].id
}
