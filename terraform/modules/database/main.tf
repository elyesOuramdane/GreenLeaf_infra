resource "aws_db_instance" "main" {
  identifier        = "${var.identifier}-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name

  multi_az               = var.multi_az
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.db_security_group_ids
  publicly_accessible    = false
  skip_final_snapshot    = true # For dev/training purposes to avoid hanging on destroy

  tags = {
    Name = "${var.identifier}-db"
  }
}
