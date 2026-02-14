#!/bin/bash

# Deploy All Services Script
# Usage: ./deploy-all.sh [environment]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ENVIRONMENT=${1:-dev}
PROJECT_NAME=${PROJECT_NAME:-OfficeEstudioGuiggi}
AWS_REGION=${AWS_REGION:-us-east-1}

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OfficeEstudioGuiggi Backend Deployment${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Environment: $ENVIRONMENT"
echo "Region: $AWS_REGION"
echo "Project: $PROJECT_NAME"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}Error: AWS credentials not configured${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed${NC}"
echo ""

# Use SAM for complete deployment
echo -e "${YELLOW}Deploying using AWS SAM...${NC}"
cd "$REPO_ROOT/infrastructure/sam"

# Check if SAM CLI is installed
if ! command -v sam &> /dev/null; then
    echo -e "${RED}Error: AWS SAM CLI is not installed${NC}"
    echo "Install it with: pip install aws-sam-cli"
    exit 1
fi

# Build
echo -e "${YELLOW}Building SAM application...${NC}"
sam build

# Deploy
echo -e "${YELLOW}Deploying to AWS...${NC}"
sam deploy --parameter-overrides "Environment=$ENVIRONMENT ProjectName=$PROJECT_NAME"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "To view the API endpoint:"
echo "aws cloudformation describe-stacks --stack-name office-estudio-guiggi-backend --query 'Stacks[0].Outputs' --region $AWS_REGION"
