# NYC Restaurant Inspections – Analytical Case Study

## Project overview

This project analyzes health inspection data released by the **New York City Department of Health and Mental Hygiene (DOHMH)** with the goal of producing a **stable, decision-oriented analytical model** suitable for KPI reporting and trend analysis.

Health inspection data is structurally complex: a single inspection can generate multiple violations, inspection scores are not additive, and raw data granularity can easily lead to analytical distortions. This project focuses explicitly on **analytical correctness** rather than surface-level aggregation.

---

## Analytical objectives

The analysis is designed to answer the following questions:

* How stable is inspection quality over time?
* How widespread are critical health risks across the city?
* Are there persistent differences between boroughs?
* Do some cuisine types systematically show worse outcomes?
* Is the inspection system improving, deteriorating, or remaining stable?

Each question is mapped to a specific KPI or metric, avoiding ambiguous or mixed-granularity interpretations.

---

## Methodological approach

The project follows a clear separation of responsibilities:

* **ETL (Power Query)**

  * Cleans and standardizes raw data
  * Preserves inspection–violation granularity
  * Performs no aggregations

* **Data model (Power BI)**

  * Simplified star schema
  * One fact table at inspection–violation level
  * Dedicated dimensions for time, area, cuisine, restaurant, and violation

* **Semantic layer (DAX)**

  * Reconstructs inspection identity analytically
  * Enforces correct aggregation logic
  * Implements rolling-window KPIs

All business logic is intentionally handled in DAX to keep the ETL layer transparent and auditable.

---

## Dashboard structure

The Power BI dashboard is divided into two complementary analytical panels.

### 1. Overview

Provides a snapshot of the inspection system through:

* Total number of inspections
* Average inspection score
* Critical inspection rate
* Best and worst cuisine rankings
* Most recurring violation codes

This panel supports fast comparative analysis across boroughs and cuisine types.

### 2. Time analysis

Focuses on medium-term dynamics using **3-year rolling metrics**:

* Inspection count (3Y rolling)
* Average inspection score (3Y rolling)
* Critical inspection rate (3Y rolling)

Rolling windows are used to reduce annual volatility while preserving sensitivity to structural change.

---

## Key findings

* Inspection quality is broadly stable over time, with persistent territorial differences
* Critical violations are widespread but show gradual improvement in recent years
* Some cuisine categories consistently exhibit higher operational risk
* Increased inspection activity after 2021 aligns with post-pandemic recovery patterns

These findings are descriptive and exploratory: no causal assumptions are made.

---

## Design principles

* Inspection scores are aggregated only at the true inspection level
* Violation-based metrics operate at row level
* No score duplication bias is allowed in KPIs
* Time trends use aggregated rolling windows, not averages of averages
* The model prioritizes clarity, stability, and auditability

---

## Tools and skills demonstrated

* Power Query (ETL design)
* Power BI data modeling
* Star schema modeling
* Advanced DAX (granularity control, rolling windows)
* Analytical documentation for portfolio presentation

---

## Documentation structure

* `etl_power_query.md` – ETL logic and transformation rules
* `data_model.md` – Conceptual and physical data model
* `dax_measures.md` – Final DAX measures and methodology
* `dashboard.md` – Dashboard structure and KPI interpretation

This project is intended as a **portfolio case study**, demonstrating an end-to-end analytical workflow from raw data to decision-ready insights.
