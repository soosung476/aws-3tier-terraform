# AWS 3-Tier Terraform 프로젝트

## 프로젝트 개요
이 프로젝트는 시스템 엔지니어 / 클라우드 운영 취업을 위한 포트폴리오 프로젝트입니다.

`aws-3tier-core-project`에서 AWS 콘솔 기반으로 먼저 구축한 3-Tier 아키텍처를,
이 저장소에서 Terraform으로 다시 코드화하고 있습니다.

즉, 이 저장소는 코어 프로젝트의 IaC 확장판이며, 직접 구성한 인프라를
"재현 가능하고 관리 가능한 코드"로 옮기는 과정을 담고 있습니다.

## 관련 저장소
- 코어 프로젝트: [aws-3tier-core-project](https://github.com/soosung476/aws-3tier-core-project)
- Terraform 프로젝트: [aws-3tier-terraform](https://github.com/soosung476/aws-3tier-terraform)

## 프로젝트 목표
- AWS 3-Tier 아키텍처를 Terraform으로 직접 구현
- 리소스를 단순 배포하는 수준이 아니라, 왜 이런 블록과 인자가 필요한지 이해
- 콘솔 중심 구축 경험을 IaC 방식으로 확장
- 실무형 클라우드 운영 관점에서 네트워크, 보안, 가용성, 운영 가시성을 함께 정리

## 인프라 구성 범위
- VPC
- Public / Private App / Private DB subnet 분리
- Internet Gateway / NAT Gateway / Route Table 구성
- ALB + Target Group + HTTP to HTTPS redirect
- Launch Template + Auto Scaling Group
- IAM Role + Instance Profile + SSM 연결
- RDS MySQL
- Route 53 + ACM 기반 도메인 연결
- CloudWatch Alarm + Dashboard

## 코어 프로젝트와의 관계
이 저장소의 Terraform 코드는 아래 코어 프로젝트에서 직접 구축한 인프라를 기준으로 작성되었습니다.

- Core Build: 네트워크, ALB, EC2, RDS 기본 구조
- 운영 고도화: IAM Role, SSM Session Manager, Instance Refresh, CloudWatch, HTTPS, ACM, Route 53
- Terraform 단계: 위 구성을 코드로 재구성하고 재배포 가능하도록 정리

코어 프로젝트 문서:
- [aws-3tier-core-project](https://github.com/soosung476/aws-3tier-core-project)

## 현재 상태
현재 인프라 구성은 완료했고, 각 Terraform 파일을 다시 읽으면서 아래 내용을 중심으로 정리 중입니다.

- Terraform 문법 이해
- 각 리소스 블록의 역할 이해
- 왜 특정 인자와 값이 필요한지 정리
- 파일별 주석 보강

## 주석 정리 완료 파일
- `vpc.tf`
- `variables.tf`
- `security.tf`
- `outputs.tf`
- `locals.tf`
- `provider.tf`
- `versions.tf`
- `alb.tf`
- `compute.tf`
- `iam.tf`
- `rds.tf`
- `dns.tf`
- `cloudwatch.tf`

## 이 저장소에서 학습한 내용
- `resource`, `data`, `variable`, `locals`, `output` 기본 구조
- 문자열 보간 `${}`
- 리스트와 map 사용 방식
- 조건식 `condition ? true_value : false_value`
- `for_each`를 이용한 반복 리소스 생성
- 리소스 간 참조와 의존성 연결 방식
- AWS 인프라 구성을 Terraform 코드로 표현하는 방법

## 다음 단계
- README 보완
- 모듈 분리
- Remote State 적용
- dev / prod 환경 분리
- GitHub Actions를 이용한 Terraform 작업 흐름 정리

## 이 프로젝트의 의미
- AWS 콘솔로 만든 인프라를 Terraform으로 다시 옮기며 IaC 역량을 증명할 수 있음
- 시스템 엔지니어 / 클라우드 운영 직무에서 중요한 네트워크, 보안, 운영 구성 이해를 함께 보여줄 수 있음
- 단순 배포가 아니라 구조 이해와 재현 가능성을 모두 담은 프로젝트임
