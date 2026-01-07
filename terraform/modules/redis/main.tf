resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.identifier}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "main" {
  count                = var.multi_az ? 0 : 1
  cluster_id           = "${var.identifier}-redis"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = var.security_group_ids

  tags = {
    Name = "${var.identifier}-redis"
  }
}

resource "aws_elasticache_replication_group" "main" {
  count                = var.multi_az ? 1 : 0
  replication_group_id = "${var.identifier}-redis-rg"
  description          = "Redis Replication Group for ${var.identifier}"
  node_type            = var.node_type
  port                 = 6379
  parameter_group_name = "default.redis6.x"
  automatic_failover_enabled = true
  
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = var.security_group_ids
  
  num_cache_clusters   = 2 # Primary + Replica

  tags = {
    Name = "${var.identifier}-redis-rg"
  }
}
