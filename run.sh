#!/usr/bin/env bash
set -euo pipefail

docker compose up -d
terraform init
terraform apply -auto-approve

echo "Done. Outputs:"
terraform output
