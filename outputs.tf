# output의 의미
# terraform apply 를 하고나면 콘솔에 output값이 나온다
# 아직 모듈화 하진 않았지마 모듈화 할 때 부모와 자식간의 값을 참조하는데 output이 사용된다고 한다
# terraform 이외의 다른 도구에다가 값을 넘길 때 output이 활용된다고 한다
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

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}
output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "rds_db_name" {
  value = aws_db_instance.mysql.db_name
}

output "app_fqdn" {
  value = local.app_fqdn
}

output "app_url" {
  value = "https://${local.app_fqdn}"
}

output "acm_certificate_arn" {
  value = data.aws_acm_certificate.selected.arn
}


output "route53_record_fqdns" {
  value = {
    for k, v in aws_route53_record.app : k => v.fqdn
  }
}

output "apex_record_fqdn" {
  value = try(aws_route53_record.app["apex"].fqdn, null)
}

output "www_record_fqdn" {
  value = try(aws_route53_record.app["app"].fqdn, null)
}
output "cloudwatch_dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}

output "cloudwatch_alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.alb_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.alb_target_response_time.alarm_name,
    aws_cloudwatch_metric_alarm.alb_unhealthy_hosts.alarm_name,
    aws_cloudwatch_metric_alarm.rds_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.rds_free_storage.alarm_name
  ]
}