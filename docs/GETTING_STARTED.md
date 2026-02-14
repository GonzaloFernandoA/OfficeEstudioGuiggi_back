# Getting Started

This guide will help you set up and deploy the OfficeEstudioGuiggi backend services on AWS.

## Prerequisites

### Required Tools

1. **AWS CLI** - For interacting with AWS services
   ```bash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

2. **AWS SAM CLI** - For serverless deployments
   ```bash
   pip install aws-sam-cli
   ```

3. **Node.js** - For Lambda functions (if using Node.js runtime)
   ```bash
   # Install Node.js 18 or higher
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

4. **jq** - For JSON processing in scripts
   ```bash
   sudo apt-get install jq
   ```

### AWS Account Setup

1. **Create an AWS Account** (if you don't have one)
   - Visit https://aws.amazon.com/
   - Follow the account creation process

2. **Configure AWS Credentials**
   ```bash
   aws configure
   ```
   You'll be prompted for:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region name (e.g., us-east-1)
   - Default output format (json)

3. **Verify Configuration**
   ```bash
   aws sts get-caller-identity
   ```

### IAM Permissions

Your AWS user/role needs permissions for:
- Lambda (full access)
- API Gateway (full access)
- CloudFormation (full access)
- IAM (create/manage roles)
- CloudWatch Logs (create/manage log groups)
- S3 (for deployment packages)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/GonzaloFernandoA/OfficeEstudioGuiggi_back.git
cd OfficeEstudioGuiggi_back
```

### 2. Deploy Using AWS SAM (Recommended)

```bash
# Navigate to SAM directory
cd infrastructure/sam

# Build the application
sam build

# Deploy (first time - guided mode)
sam deploy --guided
```

During guided deployment, you'll configure:
- Stack name: `office-estudio-guiggi-backend`
- AWS Region: Your preferred region
- Parameters:
  - Environment: `dev`, `staging`, or `prod`
  - ProjectName: `OfficeEstudioGuiggi`
- Confirm changeset before deploy: `Y`
- Allow SAM CLI IAM role creation: `Y`
- Save arguments to config: `Y`

### 3. Subsequent Deployments

After the initial setup:

```bash
cd infrastructure/sam
sam build && sam deploy
```

### 4. Deploy to Different Environments

```bash
# Development
sam deploy --parameter-overrides Environment=dev

# Production
sam deploy --parameter-overrides Environment=prod
```

## Alternative: Deploy Individual Components

### Deploy a Lambda Function

```bash
./scripts/deploy-lambda.sh example-function dev
```

### Deploy API Gateway

```bash
./scripts/deploy-api-gateway.sh example-api dev
```

## Testing Your Deployment

### Get API Endpoint

```bash
aws cloudformation describe-stacks \
  --stack-name office-estudio-guiggi-backend \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
  --output text
```

### Test Health Endpoint

```bash
# Replace with your actual API endpoint
curl https://your-api-id.execute-api.us-east-1.amazonaws.com/dev/health
```

Expected response:
```json
{
  "message": "Function executed successfully",
  "timestamp": "2026-02-14T12:00:00.000Z"
}
```

### Test POST Endpoint

```bash
curl -X POST https://your-api-id.execute-api.us-east-1.amazonaws.com/dev/example \
  -H "Content-Type: application/json" \
  -d '{"action": "test", "data": {"key": "value"}}'
```

## Local Development

### Test Lambda Functions Locally

```bash
cd infrastructure/sam

# Start local API Gateway
sam local start-api

# In another terminal, test the endpoint
curl http://localhost:3000/health
```

### Invoke Function Directly

```bash
# Create a test event
echo '{"body": "{\"action\":\"test\"}"}' > event.json

# Invoke function
sam local invoke ExampleFunction -e event.json
```

## Monitoring and Logs

### View CloudWatch Logs

```bash
# List log groups
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/OfficeEstudioGuiggi

# Tail logs
sam logs -n ExampleFunction --stack-name office-estudio-guiggi-backend --tail
```

### View Metrics

Access CloudWatch in AWS Console:
- Lambda function metrics
- API Gateway metrics
- Custom metrics (if implemented)

## Cleanup

To remove all deployed resources:

```bash
cd infrastructure/sam
sam delete
```

This will delete:
- Lambda functions
- API Gateway
- CloudWatch log groups
- IAM roles
- All other resources created by the stack

## Next Steps

- [Project Structure](./PROJECT_STRUCTURE.md) - Understanding the codebase
- [Development Guide](./DEVELOPMENT_GUIDE.md) - Adding new features
- [Deployment Guide](./DEPLOYMENT.md) - Advanced deployment options
- [Troubleshooting](./TROUBLESHOOTING.md) - Common issues and solutions

## Support

For issues or questions:
1. Check the documentation
2. Review CloudWatch logs
3. Open an issue on GitHub
