# RDS가 배치될 DB 전용 subnet 묶음
resource "aws_db_subnet_group" "main" {
  name = "${local.name_prefix}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_2a.id,
    aws_subnet.private_db_2c.id
  ]
  # DB는 외부에 직접 노출하지 않도록 private DB subnet 사용

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}

# MySQL RDS 인스턴스 생성
resource "aws_db_instance" "mysql" {
  identifier        = "${var.environment}-mysql-db"
  engine            = "mysql"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  # 초기 데이터베이스 이름과 관리자 계정 정보

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  # DB subnet group과 DB 보안 그룹 연결

  publicly_accessible = false
  multi_az            = var.db_multi_az
  # 외부 퍼블릭 접근 차단, 필요하면 Multi-AZ로 가용성 향상

  storage_encrypted   = true
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true
  # 저장소 암호화 사용
  # 실습/개발 편의를 위해 삭제 시 final snapshot은 생략
  # 변경 사항은 유지보수 시간 대기 없이 바로 적용

  tags = {
    Name = "${local.name_prefix}-mysql"
  }
}
