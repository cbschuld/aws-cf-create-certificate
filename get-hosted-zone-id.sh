#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -d DOMAIN_NAME -p AWS_PROFILE
  -d DOMAIN_NAME: DNS name of the Route 53 zone (e.g. example.com)
  -p AWS_PROFILE: AWS CLI profile name
EOF
  exit 1
}

# Ensure AWS CLI is available
if ! command -v aws >/dev/null 2>&1; then
  echo "Error: AWS CLI is not installed or not in PATH."
  exit 1
fi

# Parse arguments
while getopts ":d:p:" opt; do
  case $opt in
    d) DOMAIN_NAME=$OPTARG ;;
    p) AWS_PROFILE=$OPTARG ;;
    *) usage ;;
  esac
done

# Validate inputs
if [[ -z "${DOMAIN_NAME-}" || -z "${AWS_PROFILE-}" ]]; then
  echo "Error: missing required parameter."
  usage
fi

# Retrieve Hosted Zone ID
# strips leading '/hostedzone/' prefix
ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name "${DOMAIN_NAME}" \
  --profile "${AWS_PROFILE}" \
  --query "HostedZones[0].Id" \
  --output text | cut -d'/' -f3)

if [[ -z "$ZONE_ID" || "$ZONE_ID" == "None" ]]; then
  echo "Error: No hosted zone found for domain '${DOMAIN_NAME}'."
  exit 1
fi

echo "$ZONE_ID"

