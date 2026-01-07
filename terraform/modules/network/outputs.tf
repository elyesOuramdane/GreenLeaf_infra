output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_public_ids" {
  value = aws_subnet.public[*].id
}

output "subnet_private_ids" {
  value = aws_subnet.private[*].id
}

output "subnet_data_ids" {
  value = aws_subnet.data[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.name
}
