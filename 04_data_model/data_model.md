# Data Model

The project uses a **simplified star schema**, designed for KPI-driven analysis,
comparative reporting, and time trend evaluation.

The model prioritizes **semantic clarity, performance, and analytical correctness**
over extreme normalization.

---

## Fact table

### fact_inspections

The fact table stores restaurant inspection results at **inspection–violation granularity**.

Each row represents **one violation detected during an inspection**.

| Field | Description |
|-----|------------|
| inspection_key | Surrogate row identifier |
| date_key | Foreign key to `date_dim` |
| restaurant_key | Foreign key to `restaurant_dim` |
| area_key | Foreign key to `area_dim` |
| cuisine_key | Foreign key to `cuisine_dim` |
| violation_key | Foreign key to `violation_dim` |
| score_assigned | Inspection score |
| critical_flag | Indicates whether the violation is critical |

---

## Granularity definition

The fact table **does not store one row per inspection**.

Instead:

- one inspection can generate multiple rows
- each row corresponds to a detected violation
- the inspection score is repeated across all related rows

The **logical inspection level** is defined as:

## Relationships

<figure align="center">
  <img src="star_scheme_PBI.png" alt="Star schema of the data model - fact table and dimensions" width="700">
  <figcaption>Star schema of the data model - fact table and dimensions</figcaption>
</figure>

All relationships are:

- one-to-many
- single-direction
- from dimensions to the fact table

No bidirectional relationships or bridge tables are used, in order to maintain:


## Key methodological choices

- score-based metrics always aggregate at the true inspection level
- violation-based metrics operate at the fact table row level
- separation between operational KPIs and descriptive metrics is intentional
- the model prioritizes readability and stability over extreme normalization


To support correct aggregation, a derived inspection identifier
(`inspection_business_key`) is used at the semantic level.

> ⚠️ Note  
> `inspection_business_key` achieves ~99.2% uniqueness.
> A small number of inspections appear duplicated even when all identifying fields match.
> This behavior is known and flagged for a final verification step.

This identifier is **not part of the conceptual documentation**, as it is an implementation detail
introduced to enforce analytical correctness.

---

## Dimensions

### date_dim

| Field | Description |
|-----|------------|
| date_key | Integer date key (YYYYMMDD) |
| full_date | Calendar date |
| year | Year |
| quarter | Calendar quarter |
| month_number | Month number |
| month_name | Month name |

The date dimension supports chronological ordering and rolling window calculations.

---

### area_dim

| Field | Description |
|-----|------------|
| area_key | Area identifier |
| area_name | Borough name |

---

### cuisine_dim

| Field | Description |
|-----|------------|
| cuisine_key | Cuisine identifier |
| cuisine_type | Cuisine description |

---

### restaurant_dim

| Field | Description |
|-----|------------|
| restaurant_key | Technical key |
| restaurant_id | Original CAMIS identifier |

---

### violation_dim

| Field | Description |
|-----|------------|
| violation_key | Technical key |
| violation_code | Violation code |
| violation_description | Text description |

`violation_description` is retained for interpretability but not used for aggregations.

---

## Relationships

- one-to-many
- single-direction
- from dimensions to fact table

No bidirectional relationships or bridge tables are used.

---

## Design principles

- inspection scores aggregate only at the inspection level
- violation metrics operate at row level
- analytical logic is enforced in DAX, not ETL
- the model favors stability and interpretability over transactional detail


*Back to the [README](/README.md)*
