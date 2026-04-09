# ALB 생성
resource "aws_lb" "app" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  # internal 이 true 일 경우 내부에서만 사용하는 로드밸런서 false일 경우 퍼블릭 ALB
  load_balancer_type = "application"
  # 어플리케이션 로드밸런서 즉 ALB
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2c.id
  ]

  tags = {
    Name = "${local.name_prefix}-alb"
  }
}

# ALB가 트래픽을 listener를 통해 전달할 타겟그룹 생성
resource "aws_lb_target_group" "app" {
  name        = "${var.environment}-app-tg"
  port        = 80
  # EC2 인스턴스로 보내는 것은 80번 포트를 이용한다
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    # 200이 응답으로 오면 정상으로 판단
    healthy_threshold   = 2
    unhealthy_threshold = 2
    # 연속으로 2번 성공시 healthy 2번 실패시 unhealthy
    interval            = 30
    # 30초마다 검사
    timeout             = 5
    # 5초안에 응답이 없으면 실패로 판단
  }

  tags = {
    Name = "${local.name_prefix}-app-tg"
  }
}

# http 리스너 생성
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    # 80 포트로 접속을 하면 443포트로 리다이렉트를 한다
    # 즉 http://도메인 으로 접속을 하면 ALB가 보안 연결로 다시 오라고 https://도메인 으로 보내버림
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

# https 리스너 생성
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # TLS/SSL 정책, 어떤 보안 암호군을 사용할지 정함
  
  certificate_arn   = data.aws_acm_certificate.selected.arn
  # https연결에 사용할 acm 인증서
  # 브라우저와 ALB가 TLS핸드셰이크를 할때 보여주는 인증키
  default_action {
    type             = "forward"
    # 요청을 타겟 그룹으로 전달
    target_group_arn = aws_lb_target_group.app.arn
  }
}