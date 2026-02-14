# Infrastructure as Code

This directory contains Infrastructure as Code (IaC) templates for deploying AWS resources.

## Structure

```
infrastructure/
├── cloudformation/
│   └── ... (CloudFormation templates)
├── sam/
│   └── ... (AWS SAM templates)
├── terraform/
│   └── ... (Terraform configurations)
└── README.md
```

## Deployment Options

### Option 1: AWS SAM (Recommended for Serverless)

AWS SAM (Serverless Application Model) is ideal for Lambda functions and API Gateway.

```bash
# Install AWS SAM CLI
pip install aws-sam-cli

# Build the application
sam build

# Deploy
sam deploy --guided
```

### Option 2: CloudFormation

For more complex infrastructure or when using SAM is not suitable.

```bash
# Validate template
aws cloudformation validate-template --template-body file://template.yaml

# Deploy stack
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name office-estudio-guiggi-backend \
  --capabilities CAPABILITY_IAM
```

### Option 3: Terraform

For multi-cloud or more advanced infrastructure management.

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Best Practices

1. **Version Control**: Always commit infrastructure changes
2. **Parameterization**: Use parameters for environment-specific values
3. **Documentation**: Document all resources and their purposes
4. **Testing**: Test infrastructure changes in dev before production
5. **Security**: Follow AWS security best practices
6. **Cost Optimization**: Review and optimize resource configurations

## Environment Management

Maintain separate configurations for:
- Development
- Staging
- Production

## Resources Managed

- Lambda Functions
- API Gateway
- IAM Roles and Policies
- CloudWatch Logs
- DynamoDB Tables (if needed)
- S3 Buckets (if needed)
- Other AWS services as required
