output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}
