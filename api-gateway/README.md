# API Gateway Configuration

This directory contains all API Gateway configurations for the OfficeEstudioGuiggi backend.

## Structure

```
api-gateway/
├── apis/
│   └── example-api/
│       ├── api-definition.json
│       ├── stages.json
│       └── README.md
├── resources/
│   └── ... (resource definitions)
├── authorizers/
│   └── ... (custom authorizer configurations)
└── README.md
```

## API Definition Format

Each API should have its own directory with an `api-definition.json` file following the OpenAPI 3.0 specification.

### Example Structure

```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "API Name",
    "version": "1.0.0",
    "description": "API Description"
  },
  "paths": {
    "/resource": {
      "get": {
        "summary": "Description",
        "x-amazon-apigateway-integration": {
          "type": "aws_proxy",
          "httpMethod": "POST",
          "uri": "arn:aws:apigateway:region:lambda:path/2015-03-31/functions/arn:aws:lambda:region:account-id:function:function-name/invocations"
        }
      }
    }
  }
}
```

## Stages

Define deployment stages in `stages.json`:

```json
{
  "stages": [
    {
      "name": "dev",
      "description": "Development stage",
      "variables": {
        "environment": "development"
      }
    },
    {
      "name": "prod",
      "description": "Production stage",
      "variables": {
        "environment": "production"
      }
    }
  ]
}
```

## Deployment

Use the deployment scripts in the `/scripts` directory to deploy API Gateway configurations.

```bash
# Deploy API Gateway
./scripts/deploy-api-gateway.sh example-api dev
```

## Available APIs

- `example-api`: Example REST API configuration
