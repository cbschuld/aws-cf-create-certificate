#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -d DOMAIN_NAME -z HOSTED_ZONE_ID -a APPLICATION_NAME -p AWS_PROFILE -r AWS_REGION
  -d DOMAIN_NAME: Primary domain (e.g. example.com)
  -z HOSTED_ZONE_ID: Route 53 Hosted Zone ID
  -a APPLICATION_NAME: Name to tag resources
  -p AWS_PROFILE: AWS CLI profile name
  -r AWS_REGION: AWS region (e.g. us-east-1)
EOF
  exit 1
}

# Check for AWS CLI
if ! command -v aws >/dev/null 2>&1; then
  echo "Error: AWS CLI is not installed or not in PATH."
  exit 1
fi

# Parse options
while getopts ":d:z:a:p:r:" opt; do
  case $opt in
    d) DOMAIN_NAME=$OPTARG ;;
    z) HOSTED_ZONE_ID=$OPTARG ;;
    a) APPLICATION_NAME=$OPTARG ;;
    p) AWS_PROFILE=$OPTARG ;;
    r) AWS_REGION=$OPTARG ;;
    *) usage ;;
  esac
done

# Ensure all vars are set
if [[ -z "${DOMAIN_NAME-}" || -z "${HOSTED_ZONE_ID-}" || -z "${APPLICATION_NAME-}" || -z "${AWS_PROFILE-}" || -z "${AWS_REGION-}" ]]; then
  echo "Error: missing required parameter."
  usage
fi

# Deploy CloudFormation stack
STACK_NAME="${APPLICATION_NAME}-Certificate"

aws cloudformation deploy \
  --region "$AWS_REGION" \
  --profile "$AWS_PROFILE" \
  --template-file certificate.yml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides \
      DomainName="$DOMAIN_NAME" \
      HostedZoneId="$HOSTED_ZONE_ID" \
      ApplicationName="$APPLICATION_NAME"

echo "Deployment initiated for stack: $STACK_NAME in region: $AWS_REGION"

