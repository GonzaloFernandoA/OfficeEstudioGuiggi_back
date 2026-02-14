# AWS SAM Template

This directory contains AWS SAM (Serverless Application Model) templates for deploying the backend infrastructure.

## Files

- `template.yaml`: Main SAM template defining all resources
- `samconfig.toml`: SAM CLI configuration file

## Prerequisites

1. Install AWS SAM CLI:
```bash
pip install aws-sam-cli
```

2. Configure AWS credentials:
```bash
aws configure
```

## Deployment

### First-time deployment (guided)

```bash
# Navigate to this directory
cd infrastructure/sam

# Build the application
sam build

# Deploy with guided mode
sam deploy --guided
```

The guided mode will prompt you for:
- Stack name
- AWS Region
- Environment (dev/staging/prod)
- Confirmation before deployment

### Subsequent deployments

```bash
# Build and deploy
sam build && sam deploy
```

### Deploy to specific environment

```bash
# Development
sam deploy --parameter-overrides Environment=dev

# Production
sam deploy --parameter-overrides Environment=prod
```

## Local Testing

Test Lambda functions locally:

```bash
# Start local API
sam local start-api

# Invoke function directly
sam local invoke ExampleFunction -e events/example-event.json
```

## Validate Template

```bash
sam validate
```

## Resources Created

This template creates:
- API Gateway REST API
- Lambda Functions
- CloudWatch Log Groups
- IAM Roles and Policies

## Outputs

After deployment, the stack outputs:
- API Gateway endpoint URL
- Lambda function ARNs
- Lambda function names

## Cleanup

To remove all resources:

```bash
sam delete
```
