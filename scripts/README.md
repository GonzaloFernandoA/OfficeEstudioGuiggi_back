#!/bin/bash

# Deployment Scripts

This directory contains shell scripts for deploying AWS services.

## Available Scripts

- `deploy-lambda.sh`: Deploy a single Lambda function
- `deploy-api-gateway.sh`: Deploy API Gateway configuration
- `deploy-all.sh`: Deploy all services
- `setup-aws.sh`: Initial AWS setup and configuration

## Usage

### Deploy a Lambda Function

```bash
./scripts/deploy-lambda.sh function-name [environment]
```

Example:
```bash
./scripts/deploy-lambda.sh example-function dev
```

### Deploy API Gateway

```bash
./scripts/deploy-api-gateway.sh api-name [stage]
```

Example:
```bash
./scripts/deploy-api-gateway.sh example-api dev
```

### Deploy All Services

```bash
./scripts/deploy-all.sh [environment]
```

Example:
```bash
./scripts/deploy-all.sh prod
```

## Prerequisites

1. AWS CLI installed and configured
2. Appropriate IAM permissions
3. Environment variables configured (if needed)

## Environment Variables

Set these in your environment or in a `.env` file:

- `AWS_REGION`: AWS region (default: us-east-1)
- `AWS_ACCOUNT_ID`: Your AWS account ID
- `PROJECT_NAME`: Project name (default: OfficeEstudioGuiggi)

## Permissions Required

Deploying requires IAM permissions for:
- Lambda functions
- API Gateway
- CloudWatch Logs
- IAM roles
- S3 (for deployment packages)
