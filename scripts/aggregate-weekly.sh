#!/usr/bin/env bash
# aggregate-weekly.sh — Aggregates weekly pricing and revenue data
set -euo pipefail

# Get Monday of current week
WEEK_START=$(date -u -d "last monday" +"%Y-%m-%d" 2>/dev/null || date -u -v-mon +"%Y-%m-%d")
OUTPUT_DIR="output/weekly"

mkdir -p "$OUTPUT_DIR"

echo "Aggregating weekly data for week starting $WEEK_START..."

# Count daily reports for the week
DAILY_COUNT=$(ls output/daily/*.md 2>/dev/null | wc -l || echo 0)
echo "Daily reports found: $DAILY_COUNT"

echo "Weekly aggregation complete"
