output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "efs_sg_id" {
  value = aws_security_group.efs.id
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}

output "opensearch_sg_id" {
  value = aws_security_group.opensearch.id
}
