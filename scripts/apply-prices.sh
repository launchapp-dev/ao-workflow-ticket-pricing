#!/usr/bin/env bash
# apply-prices.sh — Applies recommended price changes to the ticketing platform
# In production: replace with actual ticketing platform API calls
set -euo pipefail

RECOMMENDATIONS_FILE="data/pricing/recommendations.json"
LOG_FILE="data/pricing/applied-changes.log"

mkdir -p "data/pricing"

if [ ! -f "$RECOMMENDATIONS_FILE" ]; then
  echo "No recommendations file found at $RECOMMENDATIONS_FILE — skipping"
  exit 0
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "[$TIMESTAMP] Applying price recommendations..."

# Parse and log recommendations (in production: call ticketing platform API)
python3 - << 'PYEOF'
import json, sys, os
from datetime import datetime, timezone

recs_file = "data/pricing/recommendations.json"
log_file = "data/pricing/applied-changes.log"
history_file = "data/pricing/history.json"

try:
    with open(recs_file) as f:
        data = json.load(f)
except FileNotFoundError:
    print("No recommendations to apply")
    sys.exit(0)

timestamp = datetime.now(timezone.utc).isoformat()
applied = []

for rec in data.get("recommendations", []):
    if rec.get("action") == "hold":
        print(f"  HOLD {rec['section']}: keeping at ${rec['current_price']:.2f}")
        continue

    # In production: call ticketing platform API here
    # e.g., requests.post(f"{API_BASE}/events/{event_id}/sections/{rec['section']}/price",
    #                     json={"price": rec['recommended_price']}, headers=auth_headers)
    print(f"  {rec['action'].upper()} {rec['section']}: ${rec['current_price']:.2f} → ${rec['recommended_price']:.2f} ({rec['pct_change']:+.1f}%)")
    applied.append({**rec, "applied_at": timestamp})

# Write history
try:
    with open(history_file) as f:
        history = json.load(f)
except FileNotFoundError:
    history = []

history.extend(applied)

with open(history_file, "w") as f:
    json.dump(history, f, indent=2)

# Append to change log
with open(log_file, "a") as f:
    for rec in applied:
        f.write(f"[{timestamp}] {rec['action'].upper()} {rec['section']}: ${rec['current_price']:.2f} → ${rec['recommended_price']:.2f}\n")

print(f"\nApplied {len(applied)} price changes")
PYEOF

echo "Price changes applied successfully"
