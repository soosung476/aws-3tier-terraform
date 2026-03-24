output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2c.id
  ]
}

output "private_app_subnet_ids" {
  value = [
    aws_subnet.private_app_2a.id,
    aws_subnet.private_app_2c.id
  ]
}

output "private_db_subnet_ids" {
  value = [
    aws_subnet.private_db_2a.id,
    aws_subnet.private_db_2c.id
  ]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}