#!/usr/bin/env bash
set -euo pipefail

# Start LocalStack (no docker compose)
docker rm -f localstack >/dev/null 2>&1 || true
docker run -d --name localstack -p 4566:4566 \
  -e SERVICES=ec2,iam,sts,logs,s3 \
  -e DEBUG=1 \
  -e AWS_DEFAULT_REGION=us-east-1 \
  localstack/localstack:latest

terraform init
terraform apply -auto-approve

echo "Done. Outputs:"
terraform output
