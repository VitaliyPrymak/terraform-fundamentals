# Terraform Infrastructure Project

## Overview
This project deploys a full-stack cloud infrastructure using Terraform. It includes a scalable backend with a PostgreSQL database (RDS), Redis for caching, and a frontend hosted on AWS S3 with CloudFront for global distribution. All services are containerized using Docker, and a CI/CD pipeline automates deployments with GitHub Actions.

## Project Structure
```
.github/workflows/           # CI/CD pipeline configurations
  ├── frontend-ci-cd.yml     # Workflow for frontend deployment
  ├── rds_backend-ci-cd.yml  # Workflow for RDS backend deployment
  ├── redis_backend-ci-cd.yml # Workflow for Redis backend deployment

backend_rds/                 # Backend service for PostgreSQL
  ├── core/
  ├── settings.py
  ├── urls.py
  ├── views.py
  ├── wsgi.py
  ├── Dockerfile
  ├── manage.py
  ├── requirements.txt

backend_redis/               # Backend service for Redis caching
  ├── core/
  ├── settings.py
  ├── urls.py
  ├── views.py
  ├── wsgi.py
  ├── Dockerfile
  ├── manage.py
  ├── requirements.txt

frontend/                    # Frontend application files
  ├── templates/
  ├── index.html
  ├── config.json
  ├── Dockerfile

terraform/                   # Terraform infrastructure as code
  ├── modules/               # Terraform modules
  ├── alb.tf                 # Application Load Balancer setup
  ├── cloudfront.tf          # CloudFront distribution
  ├── cloudwatch_logs.tf     # CloudWatch monitoring
  ├── ecs.tf                 # ECS Cluster and services
  ├── iam.tf                 # IAM roles and permissions
  ├── outputs.tf             # Terraform outputs
  ├── providers.tf           # AWS provider configuration
  ├── rds.tf                 # RDS instance setup
  ├── redis.tf               # Redis setup
  ├── s3.tf                  # S3 bucket for frontend hosting
  ├── security_groups.tf     # Security Groups for networking
  ├── vpc.tf                 # Virtual Private Cloud (VPC) setup

.gitignore                   # Ignored files for version control
README.md                    # Project documentation
```

## Prerequisites
Ensure you have the following installed before setting up the project:
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Docker](https://www.docker.com/get-started)
- [Git](https://git-scm.com/)
- Python (for backend services)

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/terraform-infrastructure.git
   cd terraform-infrastructure
   ```
2. Configure AWS credentials:
   ```sh
   aws configure
   ```
3. Initialize Terraform:
   ```sh
   cd terraform
   terraform init
   ```

## Deployment
1. Plan the Terraform infrastructure:
   ```sh
   terraform plan
   ```
2. Apply the Terraform deployment:
   ```sh
   terraform apply -auto-approve
   ```
3. Deploy backend services to AWS ECS:
   ```sh
   cd backend_rds && docker build -t backend-rds .
   aws ecs update-service --cluster ecs-cluster --service rds-service --force-new-deployment
   ```
   Repeat the process for `backend_redis` and `frontend` services.

## Architecture
- **VPC & Networking**: The project runs in an isolated AWS Virtual Private Cloud (VPC) with security groups.
- **ECS (Fargate)**: Manages containerized applications for backend services.
- **RDS (PostgreSQL)**: Database for persistent storage.
- **Redis**: Caching layer for performance optimization.
- **S3 & CloudFront**: Serves the frontend application globally.
- **Application Load Balancer**: Routes traffic between frontend and backend services.
- **IAM Roles**: Secure access policies for AWS services.

## CI/CD Pipeline
The project uses GitHub Actions to automate deployments:
- **Frontend CI/CD**: Builds and deploys frontend updates to AWS S3 and CloudFront.
- **Backend RDS CI/CD**: Updates the RDS backend service.
- **Backend Redis CI/CD**: Updates the Redis backend service.

## Monitoring & Logging
- **AWS CloudWatch**: Logs for ECS tasks and monitoring of system health.
- **Terraform Outputs**: Provides key resource information such as Load Balancer URL and database endpoints.

## Contributors
- **Vitaliy Prymak** - Project Maintainer

