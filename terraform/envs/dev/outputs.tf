output "alb_dns_name" {
  value = module.loadbalancer.alb_dns_name
}

output "rds_endpoint" {
  value = module.database.endpoint
}

output "opensearch_endpoint" {
  value = module.opensearch.endpoint
}

output "redis_hostname" {
  value = module.redis.hostname
}
