# Architecture Overview

This document describes the architecture of the OfficeEstudioGuiggi backend system.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Client Layer                         │
│                    (Web/Mobile Apps)                         │
└───────────────────────┬─────────────────────────────────────┘
                        │ HTTPS
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                      AWS API Gateway                         │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │  /health   │  │ /example   │  │   /...     │            │
│  └────────────┘  └────────────┘  └────────────┘            │
└────────────┬──────────────┬─────────────┬───────────────────┘
             │              │             │
             │ Proxy        │ Proxy       │ Proxy
             ▼              ▼             ▼
┌─────────────────────────────────────────────────────────────┐
│                     AWS Lambda Layer                         │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ Example Function │  │  Other Functions │                │
│  │   (Node.js)      │  │   (Node.js/Py)   │                │
│  └──────────────────┘  └──────────────────┘                │
└────────────┬──────────────┬─────────────┬───────────────────┘
             │              │             │
             ▼              ▼             ▼
┌─────────────────────────────────────────────────────────────┐
│                    External Services                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ DynamoDB │  │    S3    │  │   RDS    │  │   SQS    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
             │              │             │
             ▼              ▼             ▼
┌─────────────────────────────────────────────────────────────┐
│                  Monitoring & Logging                        │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  CloudWatch      │  │     X-Ray        │                │
│  │  Logs/Metrics    │  │    Tracing       │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Components

### 1. API Gateway

**Purpose**: Entry point for all API requests

**Features**:
- RESTful API endpoints
- Request/response transformation
- Rate limiting and throttling
- API key management
- CORS support
- Request validation

**Configuration**:
- Defined in `api-gateway/apis/example-api/api-definition.json`
- OpenAPI 3.0 specification
- Multiple stages (dev, staging, prod)

### 2. Lambda Functions

**Purpose**: Serverless compute for business logic

**Characteristics**:
- Event-driven execution
- Auto-scaling
- Pay-per-use pricing
- Isolated execution environment

**Current Functions**:
- **example-function**: Template function demonstrating patterns
  - Runtime: Node.js 18.x
  - Memory: 256 MB
  - Timeout: 30 seconds
  - Handler: `src/index.handler`

### 3. CloudWatch

**Purpose**: Monitoring, logging, and alerting

**Features**:
- Function logs
- API Gateway logs
- Metrics and dashboards
- Alarms and notifications
- Log retention (30 days)

### 4. IAM

**Purpose**: Security and access control

**Components**:
- Lambda execution roles
- API Gateway invoke permissions
- Resource-based policies
- Least privilege principle

## Request Flow

### Typical API Request

```
1. Client → API Gateway
   - HTTPS request to endpoint
   - API key validation (if required)
   - CORS preflight handling

2. API Gateway → Lambda
   - Request transformation
   - Proxy integration
   - Event creation

3. Lambda Function
   - Parse event
   - Execute business logic
   - Process data
   - Call external services (if needed)

4. Lambda → API Gateway
   - Return response object
   - Status code
   - Headers
   - Body

5. API Gateway → Client
   - Response transformation
   - CORS headers
   - Final response
```

### Example Request

```bash
curl -X POST https://api.example.com/dev/example \
  -H "Content-Type: application/json" \
  -d '{"action": "test", "data": {"key": "value"}}'
```

**Flow**:
1. API Gateway receives POST to `/example`
2. Validates request format
3. Invokes `example-function` Lambda
4. Lambda processes the request
5. Returns JSON response
6. API Gateway adds CORS headers
7. Client receives response

## Security Architecture

### Authentication & Authorization

```
┌─────────────────────────────────────────────────────────────┐
│                    Authentication Flow                       │
└─────────────────────────────────────────────────────────────┘

Option 1: API Key
Client → API Gateway (X-API-Key header) → Lambda

Option 2: AWS IAM (SigV4)
Client → API Gateway (AWS signature) → Lambda

Option 3: Custom Authorizer (Future)
Client → API Gateway → Lambda Authorizer → Lambda Function

Option 4: Cognito (Future)
Client → API Gateway → Cognito → Lambda Function
```

### Network Security

- **Encryption in Transit**: All traffic over HTTPS/TLS
- **Encryption at Rest**: CloudWatch logs encrypted
- **VPC Integration**: Optional for Lambda functions
- **Security Groups**: Control network access
- **Network ACLs**: Additional network layer security

### IAM Roles and Policies

```yaml
Lambda Execution Role:
  - AWSLambdaBasicExecutionRole (CloudWatch logs)
  - Custom policies for resource access
  - Least privilege principle

API Gateway:
  - Lambda invoke permissions
  - CloudWatch logs permissions
```

## Scalability

### Lambda Auto-Scaling

- **Concurrent Executions**: Automatically scales
- **Reserved Concurrency**: Can be configured per function
- **Provisioned Concurrency**: For predictable workloads

### API Gateway Scaling

- **Automatic Scaling**: Handles any request volume
- **Throttling**: Configurable per stage
  - Dev: 100 req/sec, burst 200
  - Staging: 500 req/sec, burst 1000
  - Prod: 1000 req/sec, burst 2000

### Performance Optimization

1. **Lambda Optimization**:
   - Right-sized memory allocation
   - Efficient cold start handling
   - Connection pooling for databases
   - Caching strategies

2. **API Gateway Optimization**:
   - Response caching (production)
   - Compression enabled
   - Request validation at gateway level

## Data Flow

### Synchronous Pattern

```
Client → API Gateway → Lambda → External Service → Lambda → API Gateway → Client
```

Used for:
- Real-time requests
- User-facing operations
- Immediate responses needed

### Asynchronous Pattern (Future)

```
Client → API Gateway → Lambda → SQS/SNS → Lambda (Worker) → DynamoDB
                                     ↓
                                 CloudWatch
```

Used for:
- Long-running processes
- Background jobs
- Batch processing

## Environments

### Development (dev)

- Purpose: Active development and testing
- Configuration: Debug logging, data trace enabled
- Throttling: 100 req/sec
- Cost: Optimized for flexibility

### Staging (staging)

- Purpose: Pre-production testing
- Configuration: Production-like settings
- Throttling: 500 req/sec
- Cost: Moderate

### Production (prod)

- Purpose: Live user traffic
- Configuration: Optimized for performance
- Throttling: 1000 req/sec
- Caching: Enabled (5 minutes TTL)
- Cost: Optimized for efficiency

## Disaster Recovery

### Backup Strategy

1. **Code**: Version controlled in Git
2. **Infrastructure**: Defined as code (SAM templates)
3. **Configuration**: Stored in Parameter Store
4. **Logs**: Retained for 30 days in CloudWatch

### Recovery Procedures

1. **Function Rollback**: Deploy previous version
2. **Stack Rollback**: CloudFormation automatic rollback
3. **Multi-Region**: Can be deployed to multiple regions

### RTO/RPO Targets

These are target objectives based on our infrastructure design:

- **RTO** (Recovery Time Objective): < 15 minutes
  - Achieved through: Infrastructure as Code deployment (SAM)
  - Procedure: Redeploy from Git repository to new environment
  - Dependencies: AWS services availability, deployment pipeline
  
- **RPO** (Recovery Point Objective): Near-zero
  - Achieved through: All infrastructure defined as code in Git
  - Application code: Version-controlled in repository
  - Configuration: Stored in code and Parameter Store
  - Note: For databases (when added), implement appropriate backup strategies

## Monitoring Strategy

### Metrics

**Lambda Metrics**:
- Invocations
- Duration
- Errors
- Throttles
- Concurrent executions

**API Gateway Metrics**:
- Count (requests)
- 4XX/5XX errors
- Latency
- Integration latency

### Alarms

Set up alarms for:
- Error rate > 5%
- Latency > 1 second
- Throttling events
- Cost exceeding budget

### Logging

```
CloudWatch Log Groups:
/aws/lambda/OfficeEstudioGuiggi-example-function-dev
/aws/lambda/OfficeEstudioGuiggi-example-function-prod
/aws/apigateway/OfficeEstudioGuiggi-api-dev
/aws/apigateway/OfficeEstudioGuiggi-api-prod
```

## Cost Optimization

### Lambda Costs

- Charged per request and compute time
- Optimization:
  - Right-size memory
  - Efficient code
  - Connection reuse

### API Gateway Costs

- Charged per million requests
- Optimization:
  - Response caching (prod)
  - Request validation

### CloudWatch Costs

- Charged for log ingestion and storage
- Optimization:
  - 30-day retention
  - Structured logging
  - Metric filters

## Future Enhancements

### Planned Features

1. **Database Integration**
   - DynamoDB for NoSQL data
   - RDS for relational data

2. **Authentication**
   - AWS Cognito user pools
   - Custom Lambda authorizers

3. **Messaging**
   - SQS for queuing
   - SNS for notifications

4. **Storage**
   - S3 for file storage
   - CloudFront for CDN

5. **Advanced Monitoring**
   - X-Ray distributed tracing
   - Custom metrics and dashboards

6. **CI/CD Pipeline**
   - Automated testing
   - Blue-green deployments
   - Canary releases

## Related Documentation

- [Getting Started](./GETTING_STARTED.md)
- [Deployment Guide](./DEPLOYMENT.md)
- [Project Structure](./PROJECT_STRUCTURE.md)
