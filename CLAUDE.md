# Dynamic Ticket Pricing Engine — AO Example

This project demonstrates dynamic ticket pricing for live events using AO's multi-agent
pipeline. It monitors real-time demand signals, scrapes competitor prices, models demand
elasticity, and applies revenue-optimized price adjustments automatically.

## Agents

| Agent | Model | Role |
|---|---|---|
| **demand-monitor** | claude-haiku-4-5 | Fast demand signal analysis — classifies each section as cold/warming/hot/sold-out |
| **competitor-scraper** | claude-sonnet-4-6 | Playwright-powered competitor price intelligence |
| **elasticity-modeler** | claude-sonnet-4-6 | Demand curve fitting and elasticity calculation |
| **price-optimizer** | claude-sonnet-4-6 | Generates recommendations with floor/ceiling guardrails |
| **revenue-simulator** | claude-sonnet-4-6 | Projects optimistic/base/pessimistic revenue before applying changes |
| **pricing-reporter** | claude-sonnet-4-6 | Produces pricing dashboards, daily scans, weekly reviews |

## Data Flow

```
collect-sales-data → analyze-demand → scrape-competitor-prices → model-elasticity
                                                                        ↓
                                                               optimize-prices
                                                                        ↓
                                                               simulate-revenue
                                                                        ↓
                                                              apply-price-changes
                                                                        ↓
                                                           generate-pricing-report
```

## Key Directories

- `config/` — Events, pricing rules, competitor targets, seasonality
- `data/sales/` — Sales velocity and demand signal data
- `data/competitors/` — Scraped competitor pricing
- `data/pricing/` — Elasticity models, recommendations, applied change history
- `data/simulations/` — Revenue impact projections
- `output/pricing/` — Hourly pricing reports per event
- `output/daily/` — Daily market scan summaries
- `output/weekly/` — Weekly revenue review reports
- `scripts/` — Data collection and price application scripts

## Configuration

Edit `config/events.yaml` to add your events with sections and current prices.
Edit `config/competitor-events.yaml` to target competitor events for Playwright scraping.
Edit `config/pricing-rules.yaml` to set floor/ceiling prices and change limits.

## AO Features Demonstrated

- **Decision-based routing**: demand-monitor verdict (cold/warming/hot/sold-out) routes to appropriate next phase
- **Multi-agent pipeline**: 6 specialized agents in a sequential optimization chain
- **Scheduled workflows**: Hourly price monitoring, daily market scans, weekly revenue reviews
- **Command phases**: Shell scripts for data collection and price application
- **Real tool integrations**: Playwright MCP for live competitor scraping, python3 for elasticity math
- **Output contracts**: Structured JSON from each phase feeds downstream agents
