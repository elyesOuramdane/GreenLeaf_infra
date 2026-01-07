output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "efs_sg_id" {
  value = aws_security_group.efs.id
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}
