# Deployment Guide

This guide covers various deployment scenarios and best practices for the OfficeEstudioGuiggi backend.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Deployment Methods](#deployment-methods)
- [Environment Configuration](#environment-configuration)
- [CI/CD Integration](#cicd-integration)
- [Rollback Procedures](#rollback-procedures)
- [Best Practices](#best-practices)

## Prerequisites

### Required Tools

- AWS CLI v2
- AWS SAM CLI v1.0+
- Node.js 18+ (for Node.js Lambda functions)
- jq (JSON processor)
- Git

### AWS Permissions

Required IAM permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:*",
        "apigateway:*",
        "cloudformation:*",
        "iam:*",
        "logs:*",
        "s3:*",
        "cloudwatch:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## Deployment Methods

### Method 1: AWS SAM (Recommended)

AWS SAM provides the most streamlined deployment experience.

#### Initial Deployment

```bash
cd infrastructure/sam
sam build
sam deploy --guided
```

Configuration prompts:
- Stack Name: `office-estudio-guiggi-backend`
- AWS Region: Your preferred region (e.g., `us-east-1`)
- Parameter Environment: `dev`, `staging`, or `prod`
- Parameter ProjectName: `OfficeEstudioGuiggi`
- Confirm changes before deploy: `Y`
- Allow SAM CLI IAM role creation: `Y`
- Save arguments to samconfig.toml: `Y`

#### Subsequent Deployments

```bash
cd infrastructure/sam
sam build && sam deploy
```

#### Environment-Specific Deployment

```bash
# Deploy to development
sam build && sam deploy --parameter-overrides Environment=dev

# Deploy to staging
sam build && sam deploy --parameter-overrides Environment=staging

# Deploy to production
sam build && sam deploy --parameter-overrides Environment=prod
```

### Method 2: CloudFormation

Direct CloudFormation deployment (alternative to SAM):

```bash
aws cloudformation package \
  --template-file infrastructure/sam/template.yaml \
  --s3-bucket your-deployment-bucket \
  --output-template-file packaged.yaml

aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name office-estudio-guiggi-backend \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides Environment=dev
```

### Method 3: Individual Component Deployment

Deploy specific components using helper scripts:

```bash
# Deploy a Lambda function
./scripts/deploy-lambda.sh example-function dev

# Deploy API Gateway
./scripts/deploy-api-gateway.sh example-api dev

# Deploy all components
./scripts/deploy-all.sh dev
```

## Environment Configuration

### Development Environment

```bash
sam deploy --parameter-overrides \
  Environment=dev \
  ProjectName=OfficeEstudioGuiggi
```

Features:
- Debug logging enabled
- Extended CloudWatch log retention
- Lower throttling limits
- Data trace enabled

### Staging Environment

```bash
sam deploy --parameter-overrides \
  Environment=staging \
  ProjectName=OfficeEstudioGuiggi
```

Features:
- Production-like configuration
- Moderate throttling limits
- Testing and validation

### Production Environment

```bash
sam deploy --parameter-overrides \
  Environment=prod \
  ProjectName=OfficeEstudioGuiggi
```

Features:
- Optimized performance settings
- High throttling limits
- Minimal logging
- Caching enabled

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches:
      - main
      - develop

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup SAM
        uses: aws-actions/setup-sam@v2
      
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Build and Deploy
        run: |
          cd infrastructure/sam
          sam build
          sam deploy --no-confirm-changeset --no-fail-on-empty-changeset
```

### GitLab CI

Create `.gitlab-ci.yml`:

```yaml
deploy:
  image: public.ecr.aws/sam/build-nodejs18.x
  script:
    - cd infrastructure/sam
    - sam build
    - sam deploy --no-confirm-changeset
  only:
    - main
```

## Rollback Procedures

### Automatic Rollback

SAM/CloudFormation automatically rolls back on deployment failure.

### Manual Rollback

#### Option 1: Redeploy Previous Version

```bash
git checkout <previous-commit>
cd infrastructure/sam
sam build && sam deploy
```

#### Option 2: CloudFormation Stack Rollback

```bash
aws cloudformation cancel-update-stack \
  --stack-name office-estudio-guiggi-backend

# Or continue with rollback
aws cloudformation continue-update-rollback \
  --stack-name office-estudio-guiggi-backend
```

#### Option 3: Lambda Function Rollback

```bash
# List function versions
aws lambda list-versions-by-function \
  --function-name OfficeEstudioGuiggi-example-function-dev

# Update alias to previous version
aws lambda update-alias \
  --function-name OfficeEstudioGuiggi-example-function-dev \
  --name live \
  --function-version <previous-version>
```

## Monitoring Deployment

### View Stack Events

```bash
aws cloudformation describe-stack-events \
  --stack-name office-estudio-guiggi-backend \
  --max-items 50
```

### Check Deployment Status

```bash
aws cloudformation describe-stacks \
  --stack-name office-estudio-guiggi-backend \
  --query 'Stacks[0].StackStatus'
```

### Tail Logs During Deployment

```bash
sam logs -n ExampleFunction \
  --stack-name office-estudio-guiggi-backend \
  --tail
```

## Testing After Deployment

### Get API Endpoint

```bash
API_ENDPOINT=$(aws cloudformation describe-stacks \
  --stack-name office-estudio-guiggi-backend \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
  --output text)

echo "API Endpoint: $API_ENDPOINT"
```

### Test Endpoints

```bash
# Health check
curl $API_ENDPOINT/health

# POST request
curl -X POST $API_ENDPOINT/example \
  -H "Content-Type: application/json" \
  -d '{"action": "test", "data": {"key": "value"}}'
```

### Run Integration Tests

```bash
# Set API endpoint
export API_ENDPOINT=$API_ENDPOINT

# Run tests (if you have test suite)
npm test
```

## Best Practices

### 1. Always Deploy to Dev First

```bash
# Deploy to dev
sam deploy --parameter-overrides Environment=dev

# Test thoroughly
./run-tests.sh

# Then deploy to staging/prod
sam deploy --parameter-overrides Environment=prod
```

### 2. Use Parameter Store for Secrets

Store sensitive data in AWS Systems Manager Parameter Store:

```bash
aws ssm put-parameter \
  --name "/OfficeEstudioGuiggi/dev/database-password" \
  --value "your-secure-password" \
  --type SecureString
```

Reference in Lambda:

```javascript
const AWS = require('aws-sdk');
const ssm = new AWS.SSM();

const password = await ssm.getParameter({
  Name: '/OfficeEstudioGuiggi/dev/database-password',
  WithDecryption: true
}).promise();
```

### 3. Tag All Resources

Ensure all resources have appropriate tags:

```yaml
Tags:
  Project: OfficeEstudioGuiggi
  Environment: !Ref Environment
  ManagedBy: SAM
  Owner: YourTeam
```

### 4. Enable X-Ray Tracing

For better debugging and monitoring:

```yaml
Globals:
  Function:
    Tracing: Active
  Api:
    TracingEnabled: true
```

### 5. Use Canary Deployments

For production deployments, use gradual rollout:

```yaml
DeploymentPreference:
  Type: Canary10Percent5Minutes
  Alarms:
    - !Ref FunctionErrorAlarm
```

### 6. Backup Before Major Updates

```bash
# Export stack template
aws cloudformation get-template \
  --stack-name office-estudio-guiggi-backend \
  --query 'TemplateBody' > backup-template.json
```

### 7. Monitor Costs

Set up billing alerts:

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name office-estudio-guiggi-cost-alarm \
  --alarm-description "Alert on high costs" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --period 21600 \
  --evaluation-periods 1 \
  --threshold 100 \
  --comparison-operator GreaterThanThreshold
```

## Troubleshooting

### Deployment Fails

1. Check CloudFormation events:
   ```bash
   aws cloudformation describe-stack-events \
     --stack-name office-estudio-guiggi-backend
   ```

2. Validate template:
   ```bash
   sam validate --lint
   ```

3. Check IAM permissions

### Lambda Function Errors

1. Check CloudWatch logs:
   ```bash
   sam logs -n ExampleFunction --stack-name office-estudio-guiggi-backend
   ```

2. Test locally:
   ```bash
   sam local invoke ExampleFunction -e events/test-event.json
   ```

### API Gateway Issues

1. Check API Gateway logs in CloudWatch
2. Verify Lambda integration permissions
3. Test Lambda function independently

## Cleanup

To remove all resources:

```bash
cd infrastructure/sam
sam delete
```

Or using AWS CLI:

```bash
aws cloudformation delete-stack \
  --stack-name office-estudio-guiggi-backend
```

## Related Documentation

- [Getting Started](./GETTING_STARTED.md)
- [Project Structure](./PROJECT_STRUCTURE.md)
- [AWS SAM Documentation](https://docs.aws.amazon.com/serverless-application-model/)
