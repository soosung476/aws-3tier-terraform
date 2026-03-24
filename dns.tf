data "aws_route53_zone" "main" {
  name         = "${var.domain_name}."
  private_zone = false
}

data "aws_acm_certificate" "selected" {
  domain      = var.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

locals {
  route53_records = var.record_name == "" ? {
    apex = var.domain_name
    } : {
    apex = var.domain_name
    app  = "${var.record_name}.${var.domain_name}"
  }
}


resource "aws_route53_record" "app" {
  for_each = local.route53_records

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}