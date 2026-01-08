resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.identifier}-search"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = 1
    zone_awareness_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp3"
  }

  vpc_options {
    subnet_ids         = [var.subnet_ids[0]] # Single node, single subnet
    security_group_ids = var.security_group_ids
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "es:*"
        Principal = "*"
        Effect    = "Allow"
        Resource  = "arn:aws:es:${var.region}:${var.account_id}:domain/${var.identifier}-search/*"
      }
    ]
  })

  tags = {
    Name        = "${var.identifier}-search"
    Environment = var.environment
  }
}
