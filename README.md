# aws-3tier-terraform

# 현재 상태

ChatGpt의 도움을 받아서 3tier 구축을 완료했으나 terraform 문법, 어떤 블록과 인자를 써야하는지
주석으로 정리중. 왜 이런 코드를 썼는지, 왜 이런 값들이 들어가는지에 대한 이해 후에 업데이트 할 예정.

## 현재까지 학습완료한 것들
### 기본문법
- resource
- variable 로 정의, var.<값>
- locals 로 정의, local.<값>
- 문자열 보간 "${}"형식
- output
- 리스트 사용시 [] 사용
- 조건 ? 참일때 값 : 거짓일때 값
- 

### 문서
- vpc.tf 
- variables.tf
- security.tf
- outpus.tf
- locals.tf
- provider.tf
- versions.tf
- alb.tf

### 앞으로 해야할 문서
- compute.tf
- iam.tf
- rds.tf
- dns.tf
- cloudwatch.tf

---

Terraform의 코드를 혼자 작성 가능하고, 어떤 블록이 필요한지 어떤 인자가 필요한지 등에 대한 기본 지식이 잡히면 이후

- 현 README 수정
- 모듈 분리
- remote state
- dev/prod 환경 분리
- Github Actions

진행할 예정.

