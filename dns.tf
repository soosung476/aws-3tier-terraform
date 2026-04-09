# Route 53에서 사용할 퍼블릭 호스팅 존 조회
data "aws_route53_zone" "main" {
  name         = "${var.domain_name}."
  private_zone = false
}

# ALB의 HTTPS 리스너에 연결할 ACM 인증서 조회
data "aws_acm_certificate" "selected" {
  domain      = var.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
  # 발급 완료된 인증서 중 가장 최근 것을 선택
}

locals {
  # record_name이 비어 있으면 루트 도메인만,
  # 값이 있으면 루트 도메인과 서브도메인을 함께 생성
  route53_records = var.record_name == "" ? {
    apex = var.domain_name
    } : {
    apex = var.domain_name
    app  = "${var.record_name}.${var.domain_name}"
  }
}


# Route 53 A 레코드를 생성해 도메인이 ALB를 가리키도록 설정
resource "aws_route53_record" "app" {
  for_each = local.route53_records

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value
  type    = "A"
  # ALB는 고정 IP가 아니라 DNS 이름을 사용하므로 alias 레코드로 연결

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
    # ALB 상태를 기준으로 Route 53이 응답 상태를 평가
  }
}
