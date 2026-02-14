# Example API

This is an example REST API configuration for the OfficeEstudioGuiggi backend.

## Overview

The Example API provides endpoints for:
- Health checks
- Example data processing

## Endpoints

### GET /health
Health check endpoint that returns the API status.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-02-14T12:00:00.000Z"
}
```

### POST /example
Process example data.

**Request:**
```json
{
  "action": "test",
  "data": {
    "key": "value"
  }
}
```

**Response:**
```json
{
  "message": "Function executed successfully",
  "timestamp": "2026-02-14T12:00:00.000Z"
}
```

### GET /example
Retrieve example data.

**Query Parameters:**
- `id` (optional): Resource ID

## Configuration Files

- `api-definition.json`: OpenAPI 3.0 specification
- `stages.json`: Stage configurations (dev, staging, prod)

## Deployment

Deploy this API using:

```bash
# Deploy to development
./scripts/deploy-api-gateway.sh example-api dev

# Deploy to production
./scripts/deploy-api-gateway.sh example-api prod
```

## Integration

This API integrates with the following Lambda functions:
- `example-function`: Handles all endpoint requests

## Authentication

Currently uses API Key authentication. Can be extended to use:
- AWS Cognito
- Custom Lambda authorizers
- IAM roles

## Monitoring

- CloudWatch Logs enabled
- CloudWatch Metrics enabled
- X-Ray tracing available

## Throttling

Configured per stage:
- **Dev**: 100 requests/sec, burst 200
- **Staging**: 500 requests/sec, burst 1000
- **Prod**: 1000 requests/sec, burst 2000
