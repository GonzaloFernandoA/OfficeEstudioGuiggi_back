#!/bin/bash

# Deploy API Gateway Script
# Usage: ./deploy-api-gateway.sh <api-name> [stage]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if API name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: API name is required${NC}"
    echo "Usage: $0 <api-name> [stage]"
    echo "Example: $0 example-api dev"
    exit 1
fi

API_NAME=$1
STAGE=${2:-dev}
PROJECT_NAME=${PROJECT_NAME:-OfficeEstudioGuiggi}
AWS_REGION=${AWS_REGION:-us-east-1}

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
API_DIR="$REPO_ROOT/api-gateway/apis/$API_NAME"
API_DEFINITION="$API_DIR/api-definition.json"

echo -e "${YELLOW}Deploying API Gateway: $API_NAME${NC}"
echo "Stage: $STAGE"
echo "Region: $AWS_REGION"

# Check if API directory exists
if [ ! -d "$API_DIR" ]; then
    echo -e "${RED}Error: API directory not found: $API_DIR${NC}"
    exit 1
fi

# Check if api-definition.json exists
if [ ! -f "$API_DEFINITION" ]; then
    echo -e "${RED}Error: api-definition.json not found in $API_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}Validating API definition...${NC}"
if ! jq empty "$API_DEFINITION" 2>/dev/null; then
    echo -e "${RED}Error: Invalid JSON in api-definition.json${NC}"
    exit 1
fi

echo -e "${GREEN}✓ API definition is valid${NC}"
echo ""
echo -e "${YELLOW}Note: For complete API Gateway deployment, use AWS SAM:${NC}"
echo "1. cd infrastructure/sam"
echo "2. sam build"
echo "3. sam deploy --parameter-overrides Environment=$STAGE"
echo ""
echo -e "${YELLOW}Or use AWS CLI to import the OpenAPI definition:${NC}"
echo "aws apigateway import-rest-api --body file://$API_DEFINITION --region $AWS_REGION"

echo -e "${GREEN}✓ API Gateway validation completed${NC}"
