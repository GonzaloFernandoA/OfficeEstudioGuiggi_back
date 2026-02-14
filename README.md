# OfficeEstudioGuiggi Backend

Version-controlled repository for AWS services including Lambda functions and API Gateway configurations.

## Overview

This repository provides a comprehensive structure for managing AWS backend services:
- **Lambda Functions**: Serverless compute functions
- **API Gateway**: RESTful API endpoints
- **Infrastructure as Code**: SAM/CloudFormation templates for deployment
- **Deployment Scripts**: Automated deployment tools

## Features

- ✅ Version-controlled AWS Lambda functions
- ✅ API Gateway configurations with OpenAPI 3.0 specs
- ✅ Infrastructure as Code using AWS SAM
- ✅ Multiple environment support (dev, staging, prod)
- ✅ Automated deployment scripts
- ✅ Comprehensive documentation
- ✅ Example implementations and templates

## Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- AWS SAM CLI installed
- Node.js 18+ (for Node.js Lambda functions)
- jq (for JSON processing)

### Deploy to AWS

```bash
# Clone the repository
git clone https://github.com/GonzaloFernandoA/OfficeEstudioGuiggi_back.git
cd OfficeEstudioGuiggi_back

# Navigate to SAM directory
cd infrastructure/sam

# Build and deploy
sam build
sam deploy --guided
```

### Test the API

After deployment, test your endpoints:

```bash
# Get the API endpoint from CloudFormation outputs
aws cloudformation describe-stacks \
  --stack-name office-estudio-guiggi-backend \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
  --output text

# Test health endpoint
curl https://your-api-id.execute-api.region.amazonaws.com/dev/health
```

## Repository Structure

```
├── lambdas/           # Lambda function implementations
├── api-gateway/       # API Gateway configurations
├── infrastructure/    # IaC templates (SAM, CloudFormation, Terraform)
├── scripts/          # Deployment and utility scripts
├── docs/             # Comprehensive documentation
└── README.md         # This file
```

## Documentation

- [Getting Started Guide](./docs/GETTING_STARTED.md) - Detailed setup instructions
- [Project Structure](./docs/PROJECT_STRUCTURE.md) - Repository organization
- [Lambda Functions](./lambdas/README.md) - Lambda function documentation
- [API Gateway](./api-gateway/README.md) - API configuration guide
- [Infrastructure](./infrastructure/README.md) - IaC deployment guide

## Available Services

### Lambda Functions

- **example-function**: Template Lambda function with error handling and CORS

### API Endpoints

- `GET /health` - Health check endpoint
- `POST /example` - Example POST endpoint
- `GET /example` - Example GET endpoint

## Development

### Adding a New Lambda Function

1. Create a new directory in `lambdas/`
2. Implement your function following the example structure
3. Add configuration in `function.json`
4. Update the SAM template
5. Deploy using the deployment scripts

### Adding a New API Endpoint

1. Update `api-gateway/apis/example-api/api-definition.json`
2. Add the Lambda integration
3. Redeploy using SAM

## Deployment

### Using AWS SAM (Recommended)

```bash
cd infrastructure/sam
sam build && sam deploy
```

### Using Deployment Scripts

```bash
# Deploy a specific Lambda function
./scripts/deploy-lambda.sh example-function dev

# Deploy API Gateway
./scripts/deploy-api-gateway.sh example-api dev

# Deploy everything
./scripts/deploy-all.sh dev
```

## Environments

Three environments are supported:
- **dev**: Development environment
- **staging**: Staging/testing environment
- **prod**: Production environment

Each environment has separate:
- Lambda function instances
- API Gateway stages
- CloudWatch log groups
- Configuration settings

## Monitoring

### CloudWatch Logs

View logs for Lambda functions:

```bash
sam logs -n ExampleFunction --stack-name office-estudio-guiggi-backend --tail
```

### Metrics and Alarms

Access CloudWatch in AWS Console for:
- Lambda invocation metrics
- API Gateway request metrics
- Error rates and latency

## Security

- All Lambda functions use IAM roles with least privilege
- API Gateway supports API keys and custom authorizers
- CloudWatch logs for audit trails
- Environment variables for sensitive configuration

## Cost Management

- Lambda functions use appropriate memory settings
- CloudWatch log retention configured (30 days)
- API Gateway throttling configured per stage
- Monitor costs using AWS Cost Explorer

## Contributing

1. Create a feature branch
2. Make your changes
3. Test in dev environment
4. Submit a pull request

## Cleanup

To remove all deployed resources:

```bash
cd infrastructure/sam
sam delete
```

## Support

For issues or questions:
- Check the [documentation](./docs/)
- Review CloudWatch logs
- Open an issue on GitHub

## License

ISC

## Authors

- GonzaloFernandoA

---

**Version Control for AWS Services**
- Lambda Functions ✅
- API Gateway ✅
- Infrastructure as Code ✅