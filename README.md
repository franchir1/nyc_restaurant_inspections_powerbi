# NYC Health Inspections – Analytical Dashboard (Power BI)

## Project Overview

This project presents an **analytical Power BI dashboard** built on top of the
**NYC Department of Health (DOHMH) restaurant inspection dataset**.

It shares the **same dataset, assumptions, and analytical logic** of the SQL-based
analytical project, and focuses on **visual exploration of system-level patterns**
rather than isolated inspection events.

The goal is to translate a **grain-aware dimensional model** into an
**interactive BI experience**.

---

## Analytical Focus

The dashboard is designed to answer the same core questions addressed in the SQL project:

* Are inspections distributed proportionally across NYC areas?
* Do inspection outcomes differ structurally between boroughs?
* How do inspection scores evolve over time?
* Where are critical hygiene violations concentrated?
* Do establishments improve, or do poor outcomes persist?

All insights are derived from **aggregated and normalized metrics**, never from
raw inspection rows.

---

## Dataset & Lineage

**Source:** NYC DOHMH – Restaurant Inspection Results

**Original grain:** inspection × violation

The raw dataset presents:

* duplicated inspection scores across violations
* mixed analytical grains
* no reliable inspection identifier

To resolve these issues, the dataset is transformed using the same
**ETL logic and modeling assumptions** adopted in the SQL project.

> Power BI uses the **same clean, modeled dataset** generated for SQL analysis.

---

## Data Model

The Power BI data model follows a **star schema–based design**, fully aligned
with the SQL dimensional model.

<figure align="center">
  <img src="star_schema.png" alt="Data model layout" width="700">
  <figcaption>Data model layout</figcaption>
</figure>

### Model Characteristics

* Central inspection fact table
* Conformed dimensions
* Explicit grain definition
* No metrics stored in dimensions
* No double counting when used correctly

---

## Tables Overview

### Fact Tables

#### `fact_inspection`

**Grain:** one row per restaurant-day with at least one inspection

Used for:

* inspection coverage analysis
* average inspection scores
* temporal trends
* establishment-level performance tracking

---

#### `fact_inspection_violation`

**Grain:** one row per (inspection, violation type)

Used for:

* critical violation analysis
* violation frequency and concentration
* compliance monitoring

> This table is treated as a **dependent fact** and is always analyzed
> through `fact_inspection`.

---

### Dimensions

* `date_dim` – time analysis and trends
* `area_dim` – geographic comparison (boroughs)
* `establishment_dim` – restaurant-level analysis
* `violation_dim` – violation classification

---

## Methodological Principles (Shared with SQL Project)

* Inspections are approximated at **restaurant-day level**
* Inspection scores are **unitary per inspection**
* Violations are normalized to inspection–violation grain
* All metrics are aggregated before analysis
* Early years with sparse coverage are interpreted cautiously

These principles ensure **analytical consistency across tools**.

---

## Dashboard Structure

The Power BI report is organized into analytical sections:

* **Overview KPIs**

  * Total inspections
  * Average inspection score
  * Critical violation rate

* **Geographic Analysis**

  * Inspection coverage by borough
  * Score distribution by area
  * Critical violations concentration

* **Temporal Analysis**

  * Inspection volume over time
  * Score trends
  * Seasonality patterns

* **Establishment Analysis**

  * Repeat inspections
  * Improvement vs persistence
  * High-risk establishments

---

## Key Findings (High-level)

The analysis highlights the following system-level patterns:

- Inspection coverage is broadly proportional across NYC areas.
- Structural differences exist in inspection outcomes between boroughs.
- Inspection scores show stable medium-term dynamics.
- Critical inspection risk is widespread but shows signs of decline in recent years.

All findings are derived from aggregated and normalized metrics and
should be interpreted at system level rather than at individual establishment level.


## Tooling & Technologies

* **BI Tool:** Power BI
* **Data Modeling:** Star schema
* **Data Source:** PostgreSQL / CSV export
* **Transformations:** Power Query (light), SQL (core logic)
* **Version Control:** Git / GitHub

---

## Relationship with SQL Project

This Power BI project is **not a separate analysis**, but a **visual extension**
of the SQL analytical project.

* Same dataset
* Same ETL assumptions
* Same dimensional model
* Same analytical questions

The SQL project serves as the **analytical foundation**;
Power BI focuses on **exploration, storytelling, and insight communication**.

---

## Further Documentation & Deep Dives

Supporting documentation and model components:

- **Raw source data (CSV)**  
  [`01_raw_data/`](01_raw_data/DOHMH_New_York_City_Restaurant_Inspection_Results_20260104_1k.csv)
Full dataset available [here](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j/about_data)

- **Power Query ETL documentation**  
  [`03_power_query/power_query.md`](03_power_query/power_query.md)

- **Analytical data model documentation**  
  [`04_data_model/data_model.md`](04_data_model/data_model.md)

- **DAX measures documentation**  
  [`05_dax/dax.md`](05_dax/dax.md)

- **Dashboard explanation**  
  [`06_dashboard/dashboard.md`](06_dashboard/dashboard.md)

For the underlying analytical logic and SQL implementation,
see the **SQL companion project**:  
[`nyc_restaurant_inspections_sql`](../nyc_restaurant_inspections_sql)

