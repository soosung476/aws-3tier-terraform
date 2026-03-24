resource "aws_db_subnet_group" "main" {
  name = "${local.name_prefix}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_2a.id,
    aws_subnet.private_db_2c.id
  ]

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "${var.environment}-mysql-db"
  engine            = "mysql"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  multi_az            = var.db_multi_az

  storage_encrypted   = true
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = {
    Name = "${local.name_prefix}-mysql"
  }
}