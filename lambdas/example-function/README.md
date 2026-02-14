# Example Lambda Function

This is a template Lambda function that demonstrates the structure and best practices for creating AWS Lambda functions in this repository.

## Purpose

This function serves as a starting point for creating new Lambda functions. It includes:
- Proper error handling
- CORS headers for API Gateway integration
- Logging
- JSON request/response handling

## Configuration

See `function.json` for the Lambda configuration including:
- Runtime: Node.js 18.x
- Memory: 256 MB
- Timeout: 30 seconds

## Local Testing

```bash
# Install dependencies
npm install

# Run tests
npm test

# Lint code
npm run lint
```

## Deployment

Use the deployment scripts in the `/scripts` directory to deploy this function to AWS.

```bash
# From the repository root
./scripts/deploy-lambda.sh example-function
```

## Environment Variables

- `NODE_ENV`: Environment (development/production)
- `LOG_LEVEL`: Logging level (debug/info/warn/error)

## Usage

This function can be triggered by:
- API Gateway HTTP requests
- Direct Lambda invocations
- Other AWS services

Example request:
```json
{
  "action": "test",
  "data": {
    "key": "value"
  }
}
```

Example response:
```json
{
  "message": "Function executed successfully",
  "input": { ... },
  "timestamp": "2026-02-14T12:00:00.000Z"
}
```
