#!/usr/bin/env bash
# collect-daily.sh — Aggregates hourly data for the daily market scan
set -euo pipefail

DATE=$(date -u +"%Y-%m-%d")
DAILY_DIR="data/sales/daily"
OUTPUT_DIR="output/daily"

mkdir -p "$DAILY_DIR" "$OUTPUT_DIR"

echo "Collecting daily data for $DATE..."

# Count hourly reports generated today
REPORT_COUNT=$(ls output/pricing/*/"${DATE}"*.md 2>/dev/null | wc -l || echo 0)
echo "Hourly reports found: $REPORT_COUNT"

# Aggregate sales data (in production: pull from ticketing platform reporting API)
echo "Daily collection complete for $DATE"
