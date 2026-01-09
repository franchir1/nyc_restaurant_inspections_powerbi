# NYC Health Inspections — Analytical Dashboard (Power BI)

## Project Overview

This project presents an **analytical Power BI dashboard** built on top of the
**NYC Department of Health (DOHMH) restaurant inspection dataset**.

It shares the **same dataset, assumptions, and analytical logic** as the SQL-based
project and focuses on **visual exploration of system-level patterns** rather than
individual inspection events.

The objective is to translate a **grain-aware dimensional model** into an
**interactive BI layer** while preserving analytical correctness.

---

## Analytical Scope

The dashboard addresses the same core analytical questions explored in the SQL project:

- Are inspections distributed proportionally across NYC areas?
- Do inspection outcomes differ structurally between boroughs?
- How do inspection scores evolve over time?
- Where are critical hygiene violations geographically concentrated?
- Do establishments improve over time or show persistent underperformance?

All insights are derived from **aggregated and normalized metrics**, never from
raw inspection rows.

---

## Dataset & Lineage

**Source:** NYC DOHMH — Restaurant Inspection Results  
**Original grain:** inspection × violation

Key issues in the raw dataset:

- duplicated inspection scores across violations
- mixed analytical grains
- absence of a reliable inspection identifier

These issues are resolved using the **same ETL logic and modeling assumptions**
adopted in the SQL project.

> Power BI consumes the **clean, modeled dataset** produced for SQL analysis.

---

## Data Model

The Power BI data model follows a **star schema–based design**, fully aligned with
the SQL dimensional model.

*(diagram unchanged)*

### Model Characteristics

- central inspection fact table
- conformed dimensions
- explicit grain definition
- no metrics stored in dimensions
- no double counting when used correctly

---

## Tables Overview

### Fact Tables

#### `fact_inspection`

**Grain:** one row per restaurant-day with at least one inspection

Used for:
- inspection coverage analysis
- average inspection score analysis
- temporal trend analysis
- establishment-level performance tracking

---

#### `fact_inspection_violation`

**Grain:** one row per (inspection, violation type)

Used for:
- critical violation analysis
- violation frequency and concentration
- compliance pattern monitoring

> This table is treated as a **dependent fact** and is always analyzed
> through `fact_inspection`.

---

### Dimensions

- `date_dim` — time-based analysis and trends
- `area_dim` — geographic comparison (boroughs)
- `establishment_dim` — restaurant-level analysis
- `violation_dim` — violation classification

---

## Methodological Principles

The dashboard adheres to the same analytical constraints as the SQL project:

- inspections approximated at **restaurant-day level**
- inspection scores treated as **unitary per inspection**
- violations normalized to inspection–violation grain
- metrics aggregated prior to analysis
- early years with sparse coverage interpreted cautiously

This ensures **analytical consistency across tools**.

---

## Dashboard Structure

The Power BI report is organized into analytical sections:

### Overview KPIs
- total inspections
- average inspection score
- critical violation rate

### Geographic Analysis
- inspection coverage by borough
- score distribution by area
- concentration of critical violations

### Temporal Analysis
- inspection volume over time
- score trends
- seasonality patterns

### Establishment Analysis
- repeat inspections
- improvement vs persistence
- identification of higher-risk establishments

---

## High-Level Findings

The analysis highlights the following system-level patterns:

- inspection coverage is broadly proportional across NYC areas
- structural differences exist in inspection outcomes between boroughs
- inspection scores exhibit stable medium-term dynamics
- critical inspection risk is widespread but shows signs of decline in recent years

All findings are based on **aggregated, normalized metrics** and should be
interpreted at **system level**, not at individual establishment level.

---

## Tools & Technologies

- **BI Tool:** Power BI
- **Data Modeling:** Star schema
- **Data Source:** PostgreSQL / CSV export
- **Transformations:** Power Query (light), SQL (core logic)
- **Version Control:** Git / GitHub

---

## Relationship with SQL Project

This Power BI project is **not a separate analysis**, but a **visual extension**
of the SQL analytical project.

- same dataset
- same ETL assumptions
- same dimensional model
- same analytical questions

The SQL project provides the **analytical foundation**;  
Power BI focuses on **exploration, comparison, and insight communication**.

---

## Documentation & Deep Dives

- Raw source data  
  [`01_raw_data/`](01_raw_data/DOHMH_New_York_City_Restaurant_Inspection_Results_20260104_1k.csv)

- Power Query documentation  
  [`03_power_query/power_query.md`](03_power_query/power_query.md)

- Data model documentation  
  [`04_data_model/data_model.md`](04_data_model/data_model.md)

- DAX measures  
  [`05_dax/dax.md`](05_dax/dax.md)

- Dashboard explanation  
  [`06_dashboard/dashboard.md`](06_dashboard/dashboard.md)

- PowerBI file
  [nyc_restaurant_inspection_PowerBI](/02_clean_data/nyc_restaurant_inspection_PowerBI.pbix)

For the underlying analytical logic, see the companion project:  
[`nyc_restaurant_inspections_sql`](../nyc_restaurant_inspections_sql)
