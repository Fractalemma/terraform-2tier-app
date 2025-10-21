# AWS 2-tier Architeccture using Terraform

## Overall description

### Internet-facing tier (web applicaction)

- Route53:
  - Domain registration:
    - Manual provision
    - Includes a Public Hosted Zone
  - Alias record:
    - Points to the Internet Gateway (which is in front of the ALB)
    - Free of cost
    - Can't set TTL (CNAME can)
- AMC - AWS Certificate Manager - Puclic certificate:
  - Manual provision
  - Pending approval
- Internet Gateway:
  - between R53 and ALB
  - At VPC level
- Application Load Balancer:
  - HTTPS listener (if SSL/TLS cert is available):
    - Points to the target group
    - Scurity policy: leave default
    - Load cert from ACM
- Auto Scaling Group:
  - Launch Template for EC2s
  - Deploy in two AZs
  - 1 EC2 per AZ:
    - Capacity:
      - Desired: 2
      - Min: 2
      - Max: 3
  - Attached to ALB: point to ALB's target group
  - Balanced best effort (default)
  - Health checks

### Data tier (database)

- Primary DB (RDS EC2)
- Replica DB (RDS EC2)

Notes:

- Each EC2 (4) has a Security Group and subnet (all private)
- Everything is inside a private VPC exept for the R53 and ACM resources

## List of resources

- ASG:
  - Target tracking policy: CPU utiization 66%
- Launch Template
- Target group

## Naming conventions

- Files and folders: kabeb-case
- Variables: snake_case
