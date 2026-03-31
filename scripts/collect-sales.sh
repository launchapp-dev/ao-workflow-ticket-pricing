#!/usr/bin/env bash
# collect-sales.sh — Fetches current ticket inventory and sales velocity data
# In production: replace with actual ticketing platform API calls (Ticketmaster, AXS, etc.)
set -euo pipefail

TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%S")
OUTPUT_FILE="data/sales/latest.json"
HISTORY_DIR="data/sales"

mkdir -p "$HISTORY_DIR"

cat > "$OUTPUT_FILE" << EOF
{
  "collected_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "events": [
    {
      "event_id": "EVT-001",
      "sections": [
        {
          "section": "floor",
          "capacity": 500,
          "sold": 455,
          "remaining": 45,
          "sold_last_hour": 23,
          "sold_prev_hour": 11
        },
        {
          "section": "lower-bowl",
          "capacity": 3000,
          "sold": 2100,
          "remaining": 900,
          "sold_last_hour": 45,
          "sold_prev_hour": 50
        },
        {
          "section": "upper-bowl",
          "capacity": 5000,
          "sold": 2800,
          "remaining": 2200,
          "sold_last_hour": 30,
          "sold_prev_hour": 55
        },
        {
          "section": "vip-package",
          "capacity": 100,
          "sold": 98,
          "remaining": 2,
          "sold_last_hour": 2,
          "sold_prev_hour": 1
        }
      ]
    },
    {
      "event_id": "EVT-002",
      "sections": [
        {
          "section": "courtside",
          "capacity": 80,
          "sold": 60,
          "remaining": 20,
          "sold_last_hour": 3,
          "sold_prev_hour": 5
        },
        {
          "section": "lower-level",
          "capacity": 2500,
          "sold": 1800,
          "remaining": 700,
          "sold_last_hour": 35,
          "sold_prev_hour": 40
        },
        {
          "section": "upper-level",
          "capacity": 6000,
          "sold": 2100,
          "remaining": 3900,
          "sold_last_hour": 20,
          "sold_prev_hour": 35
        }
      ]
    }
  ]
}
EOF

echo "Sales data collected: $OUTPUT_FILE"
