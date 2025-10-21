# AWS 2-tier Architeccture using Terraform

## Overall description

This is a TF project to provision the infra for a 2-tier architecture/applicaction:

- Web Tier: internet-facing (EC2s behind an ALB)
- Data Tier: RDS database

To meet the HA (High Availability) requirement both tiers are deployed in two AZs

### Internet-facing tier (web applicaction)

- Route53:
  - Domain registration:
    - Manual provision
    - Includes a Public Hosted Zone
  - A Alias record:
    - Points to the Internet Gateway (which is in front of the ALB)
    - Free of cost
- ACM - AWS Certificate Manager - Puclic certificate:
  - Manual provision
  - Pending approval (not included in the current state -> HTTP traffic)
- Internet Gateway:
  - At VPC level
  - Provides internet accesss to NAT gateways
- Application Load Balancer:
  - HTTP listener:
    - Points to the target group
  - HTTPS listener (future implementation when ACM Cert is available):
    - Points to the target group
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

- 6 Subnets needed:
  - 2 Public Subnets for NAT Gateways (pub-sub-a, pub-sub-b)
  - 2 Private Subnets for Web Tier (pri-sub-web-a, pri-sub-web-b)
  - 2 Private Subnets for Data Tier (pri-sub-data-a, pri-sub-data-b)
- Everything is inside a VPC exept for the R53 and ACM resources
- 3 Security Groups are needed:
  - For the ALB
  - For the Web Tier (the ASG)
  - For the Data Tier (attached to the RDS deployment)

## Naming conventions

- Files and folders: kabeb-case
- Variables: snake_case
