# Project Structure

This document describes the organization of the OfficeEstudioGuiggi backend repository.

## Directory Structure

```
OfficeEstudioGuiggi_back/
├── lambdas/                    # Lambda functions
│   ├── example-function/       # Example Lambda function
│   │   ├── src/               # Source code
│   │   │   └── index.js       # Main handler
│   │   ├── tests/             # Unit tests
│   │   ├── package.json       # Dependencies
│   │   ├── function.json      # Function configuration
│   │   └── README.md          # Function documentation
│   └── README.md              # Lambda functions overview
│
├── api-gateway/                # API Gateway configurations
│   ├── apis/                  # API definitions
│   │   └── example-api/       # Example API
│   │       ├── api-definition.json    # OpenAPI 3.0 spec
│   │       ├── stages.json            # Stage configurations
│   │       └── README.md              # API documentation
│   ├── resources/             # Shared resources
│   ├── authorizers/           # Custom authorizers
│   └── README.md              # API Gateway overview
│
├── infrastructure/             # Infrastructure as Code
│   ├── sam/                   # AWS SAM templates
│   │   ├── template.yaml      # Main SAM template
│   │   ├── samconfig.toml     # SAM configuration
│   │   └── README.md          # SAM deployment guide
│   ├── cloudformation/        # CloudFormation templates
│   ├── terraform/             # Terraform configurations
│   └── README.md              # Infrastructure overview
│
├── scripts/                    # Deployment scripts
│   ├── deploy-lambda.sh       # Deploy Lambda function
│   ├── deploy-api-gateway.sh  # Deploy API Gateway
│   ├── deploy-all.sh          # Deploy all services
│   └── README.md              # Scripts documentation
│
├── docs/                       # Documentation
│   ├── GETTING_STARTED.md     # Getting started guide
│   ├── PROJECT_STRUCTURE.md   # This file
│   ├── DEVELOPMENT_GUIDE.md   # Development guide
│   └── DEPLOYMENT.md          # Deployment guide
│
├── .gitignore                  # Git ignore rules
└── README.md                   # Project README
```

## Key Components

### Lambda Functions (`/lambdas`)

Each Lambda function is organized in its own directory with:
- **src/**: Source code
- **tests/**: Unit and integration tests
- **package.json** or **requirements.txt**: Dependencies
- **function.json**: Function configuration (runtime, memory, timeout, etc.)
- **README.md**: Function-specific documentation

### API Gateway (`/api-gateway`)

API Gateway configurations organized by API:
- **api-definition.json**: OpenAPI 3.0 specification with AWS extensions
- **stages.json**: Stage-specific configurations (dev, staging, prod)
- **README.md**: API documentation including endpoints and examples

### Infrastructure (`/infrastructure`)

Infrastructure as Code templates:
- **sam/**: AWS SAM templates (recommended for serverless)
- **cloudformation/**: Raw CloudFormation templates
- **terraform/**: Terraform configurations (for multi-cloud)

### Scripts (`/scripts`)

Deployment and utility scripts:
- **deploy-lambda.sh**: Deploy individual Lambda functions
- **deploy-api-gateway.sh**: Deploy API Gateway configurations
- **deploy-all.sh**: Complete deployment using SAM

### Documentation (`/docs`)

Comprehensive project documentation:
- **GETTING_STARTED.md**: Setup and quick start guide
- **PROJECT_STRUCTURE.md**: Repository organization (this file)
- **DEVELOPMENT_GUIDE.md**: Development workflows and best practices
- **DEPLOYMENT.md**: Detailed deployment instructions

## File Conventions

### Lambda Functions

```
function-name/
├── src/
│   └── index.js (or index.py, index.go, etc.)
├── tests/
│   └── index.test.js
├── package.json (or requirements.txt)
├── function.json
└── README.md
```

### API Gateway APIs

```
api-name/
├── api-definition.json
├── stages.json
└── README.md
```

## Naming Conventions

### Lambda Functions
- Use lowercase with hyphens: `create-user`, `process-order`
- Be descriptive but concise
- Group related functions with prefixes: `user-create`, `user-update`, `user-delete`

### API Gateway
- Use descriptive names: `main-api`, `admin-api`, `public-api`
- Match API purpose and scope

### Environment Variables
- Use UPPER_CASE with underscores: `NODE_ENV`, `LOG_LEVEL`, `DATABASE_URL`

### Tags
All AWS resources are tagged with:
- **Project**: `OfficeEstudioGuiggi`
- **Environment**: `dev`, `staging`, or `prod`
- Additional custom tags as needed

## Version Control

### What to Commit
- Source code
- Configuration files
- Infrastructure as Code templates
- Documentation
- Scripts

### What to Ignore
- Dependencies (`node_modules/`, Python packages)
- Build artifacts
- Deployment packages (`.zip`, `.jar`)
- Environment-specific files (`.env`)
- IDE configuration (`.vscode/`, `.idea/`)

See `.gitignore` for complete list.

## Adding New Components

### Adding a New Lambda Function

1. Create directory: `lambdas/new-function/`
2. Add source code in `src/`
3. Create `function.json` with configuration
4. Add `package.json` or `requirements.txt`
5. Write tests in `tests/`
6. Document in `README.md`
7. Update `infrastructure/sam/template.yaml`

### Adding a New API

1. Create directory: `api-gateway/apis/new-api/`
2. Create `api-definition.json` with OpenAPI spec
3. Create `stages.json` with stage configurations
4. Document in `README.md`
5. Update SAM template to include the API

### Adding Infrastructure

1. Update `infrastructure/sam/template.yaml`
2. Add necessary resources
3. Define outputs
4. Test with `sam build` and `sam validate`
5. Deploy to dev first for testing

## Related Documentation

- [Getting Started](./GETTING_STARTED.md)
- [Development Guide](./DEVELOPMENT_GUIDE.md)
- [Deployment Guide](./DEPLOYMENT.md)
