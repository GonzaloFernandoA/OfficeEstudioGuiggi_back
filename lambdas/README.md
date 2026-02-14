# Lambda Functions

This directory contains all AWS Lambda functions for the OfficeEstudioGuiggi backend.

## Structure

Each Lambda function should have its own directory with the following structure:

```
function-name/
├── src/
│   ├── index.js (or index.py)
│   └── ... (other source files)
├── tests/
│   └── ... (test files)
├── package.json (for Node.js) or requirements.txt (for Python)
├── function.json (function configuration)
└── README.md (function documentation)
```

## Naming Convention

- Use lowercase with hyphens for function names
- Be descriptive but concise
- Example: `create-user`, `process-order`, `send-notification`

## Configuration

Each function should have a `function.json` file with the following structure:

```json
{
  "name": "function-name",
  "runtime": "nodejs18.x",
  "handler": "index.handler",
  "timeout": 30,
  "memorySize": 256,
  "environment": {
    "VARIABLE_NAME": "value"
  },
  "role": "arn:aws:iam::account-id:role/lambda-role"
}
```

## Deployment

See the main README and the `/scripts` directory for deployment instructions.

## Available Functions

- `example-function`: Example Lambda function template (Node.js)
