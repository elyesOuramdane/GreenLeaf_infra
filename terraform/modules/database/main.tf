resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.identifier}-db-subnet-group"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.identifier}-db-sg"
  description = "Allow inbound traffic from application layer"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.identifier}-db-sg"
  }
}

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
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  skip_final_snapshot    = true # For dev/training purposes to avoid hanging on destroy

  tags = {
    Name = "${var.identifier}-db"
  }
}
