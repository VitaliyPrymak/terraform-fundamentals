# Terraform Fundamentals

## Overview
This project deploys a scalable backend using Terraform, with a PostgreSQL database (RDS) for storage and Redis for caching. The frontend is hosted on AWS S3 and CloudFront for efficient delivery. All services are containerized using Docker, and a CI/CD pipeline automates deployments.

## Project Structure
```
terraform-fundamentals/
├── .github/workflows/       # CI/CD configurations
├── backend_rds/             # Backend service for PostgreSQL
├── backend_redis/           # Backend service for Redis caching
├── frontend/                # Frontend deployment files
├── terraform/               # Terraform infrastructure as code
│   ├── modules/             # Terraform modules
│   ├── alb.tf               # Application Load Balancer setup
│   ├── cloudfront.tf        # CloudFront configuration
│   ├── ecs.tf               # ECS Cluster and Services
│   ├── iam.tf               # IAM roles and permissions
│   ├── rds.tf               # RDS instance setup
│   ├── redis.tf             # Redis setup
│   ├── security_groups.tf   # Security Groups for networking
│   ├── providers.tf         # Terraform provider configurations
│   ├── outputs.tf           # Terraform outputs
└── .gitignore               # Ignored files for version control
```

## Prerequisites
Ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI
- Docker
- Git
- Python (for backend services)

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/terraform-fundamentals.git
   cd terraform-fundamentals
   ```
2. Set up AWS credentials:
   ```sh
   aws configure
   ```
3. Install Terraform dependencies:
   ```sh
   terraform init
   ```

## Deployment
1. Plan the Terraform deployment:
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
   aws ecs update-service --cluster main-ecs-cluster --service rds-service --force-new-deployment
   ```
   Repeat for `backend_redis` and `frontend` services.

## Architecture
- **Backend RDS**: Runs on AWS ECS (Fargate), connects to PostgreSQL RDS.
- **Backend Redis**: Runs on AWS ECS (Fargate), connects to Redis for caching.
- **Frontend**: Served via AWS S3 and CloudFront.
- **Load Balancer**: AWS ALB routes traffic to ECS services.
- **Security**: IAM roles, security groups, and encrypted database connections.

## CI/CD Pipeline
The project includes GitHub Actions workflows to automate deployment:
- **Frontend CI/CD**: Deploys frontend updates to AWS S3 and CloudFront.
- **Backend RDS CI/CD**: Updates RDS backend service.
- **Backend Redis CI/CD**: Updates Redis backend service.

## Contributors
- **Vitaliy Prymak** - Project Maintainer

## License
This project is licensed under the MIT License.

