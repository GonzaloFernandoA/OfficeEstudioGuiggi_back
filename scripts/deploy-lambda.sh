#!/bin/bash

# Deploy Lambda Function Script
# Usage: ./deploy-lambda.sh <function-name> [environment]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if function name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Function name is required${NC}"
    echo "Usage: $0 <function-name> [environment]"
    echo "Example: $0 example-function dev"
    exit 1
fi

FUNCTION_NAME=$1
ENVIRONMENT=${2:-dev}
PROJECT_NAME=${PROJECT_NAME:-OfficeEstudioGuiggi}
AWS_REGION=${AWS_REGION:-us-east-1}

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
FUNCTION_DIR="$REPO_ROOT/lambdas/$FUNCTION_NAME"
FUNCTION_CONFIG="$FUNCTION_DIR/function.json"

echo -e "${YELLOW}Deploying Lambda function: $FUNCTION_NAME${NC}"
echo "Environment: $ENVIRONMENT"
echo "Region: $AWS_REGION"

# Check if function directory exists
if [ ! -d "$FUNCTION_DIR" ]; then
    echo -e "${RED}Error: Function directory not found: $FUNCTION_DIR${NC}"
    exit 1
fi

# Check if function.json exists
if [ ! -f "$FUNCTION_CONFIG" ]; then
    echo -e "${RED}Error: function.json not found in $FUNCTION_DIR${NC}"
    exit 1
fi

# Navigate to function directory
cd "$FUNCTION_DIR"

# Read configuration
RUNTIME=$(jq -r '.runtime // "nodejs18.x"' "$FUNCTION_CONFIG")
HANDLER=$(jq -r '.handler // "index.handler"' "$FUNCTION_CONFIG")
TIMEOUT=$(jq -r '.timeout // 30' "$FUNCTION_CONFIG")
MEMORY_SIZE=$(jq -r '.memorySize // 256' "$FUNCTION_CONFIG")

echo -e "${YELLOW}Installing dependencies...${NC}"
# Install dependencies based on runtime
if [[ "$RUNTIME" == nodejs* ]]; then
    if [ -f "package.json" ]; then
        npm install --production
    fi
elif [[ "$RUNTIME" == python* ]]; then
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt -t .
    fi
fi

# Create deployment package
echo -e "${YELLOW}Creating deployment package...${NC}"
ZIP_FILE="/tmp/${FUNCTION_NAME}-${ENVIRONMENT}.zip"
zip -r "$ZIP_FILE" . -x "*.git*" "tests/*" "*.md" "node_modules/.cache/*"

# Full function name with environment
FULL_FUNCTION_NAME="${PROJECT_NAME}-${FUNCTION_NAME}-${ENVIRONMENT}"

# Check if function exists
echo -e "${YELLOW}Checking if function exists...${NC}"
if aws lambda get-function --function-name "$FULL_FUNCTION_NAME" --region "$AWS_REGION" 2>/dev/null; then
    echo -e "${YELLOW}Updating existing function...${NC}"
    aws lambda update-function-code \
        --function-name "$FULL_FUNCTION_NAME" \
        --zip-file "fileb://$ZIP_FILE" \
        --region "$AWS_REGION"
    
    echo -e "${YELLOW}Updating function configuration...${NC}"
    aws lambda update-function-configuration \
        --function-name "$FULL_FUNCTION_NAME" \
        --runtime "$RUNTIME" \
        --handler "$HANDLER" \
        --timeout "$TIMEOUT" \
        --memory-size "$MEMORY_SIZE" \
        --region "$AWS_REGION"
else
    echo -e "${YELLOW}Creating new function...${NC}"
    echo -e "${RED}Note: You need to provide --role parameter. Please use AWS SAM or CloudFormation for complete deployment.${NC}"
    echo "Run: cd infrastructure/sam && sam build && sam deploy"
fi

# Cleanup
rm -f "$ZIP_FILE"

echo -e "${GREEN}✓ Lambda function deployment completed successfully${NC}"
echo "Function: $FULL_FUNCTION_NAME"
