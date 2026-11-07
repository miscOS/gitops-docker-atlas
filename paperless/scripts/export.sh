#!/bin/bash
cd /home/ubuntu/gitops/paperless
docker compose exec -T paperless document_exporter ../export -p