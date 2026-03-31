# Dynamic Ticket Pricing Engine

An autonomous ticket pricing pipeline built with [AO](https://github.com/launchapp-dev/ao). Monitor real-time demand, scrape competitor prices, model demand elasticity, and apply revenue-optimized price adjustments — all on autopilot.

## What It Does

- **Demand monitoring**: Classifies each event section as cold/warming/hot/sold-out based on sales velocity and inventory pressure
- **Competitor intelligence**: Uses Playwright to scrape live ticket prices from competing events
- **Elasticity modeling**: Fits demand curves from 90 days of historical sell-through data
- **Price optimization**: Generates recommendations with configurable floor/ceiling guardrails and flash-sale triggers
- **Revenue simulation**: Projects optimistic/base/pessimistic revenue before applying any changes
- **Automated reporting**: Hourly pricing updates, daily market scans, weekly revenue reviews

## Quick Start

```bash
# 1. Install AO
npm install -g @launchapp-dev/ao

# 2. Clone this repo
git clone https://github.com/launchapp-dev/ao-example-ticket-pricing
cd ao-example-ticket-pricing

# 3. Configure your events
# Edit config/events.yaml with your events, sections, and current prices
# Edit config/competitor-events.yaml with competitor event URLs to scrape

# 4. (Optional) Copy env file — no API keys required for core functionality
cp .env.example .env

# 5. Start the daemon
ao daemon start --autonomous

# 6. Run the pricing pipeline now
ao workflow run price-monitor

# 7. Watch it work
ao daemon stream --pretty
```

## Schedules

Once the daemon is running, workflows execute automatically:

| Workflow | Schedule | Purpose |
|---|---|---|
| `price-monitor` | Every hour | Real-time demand monitoring and price adjustment |
| `daily-market-scan` | Daily at 7am UTC | Competitor scan + daily pricing summary |
| `weekly-revenue-review` | Mondays at 9am UTC | Weekly performance review and strategy |

## Agents

| Agent | Model | Role |
|---|---|---|
| `demand-monitor` | Haiku | Sales velocity analysis → cold/warming/hot/sold-out classification |
| `competitor-scraper` | Sonnet | Playwright-powered competitor price scraping |
| `elasticity-modeler` | Sonnet | Historical demand curve fitting |
| `price-optimizer` | Sonnet | Revenue-maximizing price recommendations |
| `revenue-simulator` | Sonnet | Pre-flight revenue impact projections |
| `pricing-reporter` | Sonnet | Dashboards, daily scans, weekly reviews |

## Decision Flow

The pipeline uses AO's verdict routing to adapt behavior:

```
analyze-demand verdict:
  - sold-out → skip to report (no pricing action needed)
  - hot      → skip competitor scraping (demand justifies increase, go straight to elasticity)
  - warming  → full pipeline (scrape + optimize)
  - cold     → full pipeline (scrape + find why demand is lagging)

optimize-prices verdict:
  - hold       → skip simulation (no change to apply)
  - increase   → simulate → apply
  - decrease   → simulate → apply
  - flash-sale → simulate → apply (emergency discount, < 6h to event)
```

## Configuration

### `config/events.yaml`
Add your events with sections and current prices. Each section needs capacity and current_price.

### `config/pricing-rules.yaml`
Key settings:
- `max_increase_pct` / `max_decrease_pct` — maximum price change per interval (default: 15% / 10%)
- `floor_price_multiplier` / `ceiling_price_multiplier` — hard guardrails (default: 0.7x / 3.0x face value)
- `flash_sale.unsold_threshold_pct` — trigger flash sale if > 40% unsold within 6 hours of event

### `config/competitor-events.yaml`
Add competitor event URLs for Playwright to scrape. The scraper extracts prices by tier and availability signals.

## Tools Used

| Tool | Purpose |
|---|---|
| `@modelcontextprotocol/server-filesystem` | Read/write sales data, reports, config |
| `@modelcontextprotocol/server-sequential-thinking` | Complex reasoning for elasticity and optimization |
| `@playwright/mcp` | Live competitor price scraping |
| `python3` | Data collection aggregation in shell scripts |
| `bash` | Data collection and price application scripts |

## AO Features Demonstrated

- **Scheduled workflows** — Hourly, daily, and weekly automation with 5-field cron
- **Multi-agent pipeline** — 6 specialized agents in a revenue optimization chain
- **Decision contracts** — Verdict-based routing (cold/warming/hot/sold-out, hold/increase/decrease/flash-sale)
- **Command phases** — Shell scripts for data collection and price application
- **Real web scraping** — Playwright MCP for live competitor intelligence
- **Output contracts** — Structured JSON flows between agents

## Output

- `output/pricing/{event_id}/{timestamp}.md` — Hourly pricing reports
- `output/daily/{date}.md` — Daily market scan summaries
- `output/weekly/{date}.md` — Weekly revenue reviews
- `data/pricing/history.json` — Applied price change log
