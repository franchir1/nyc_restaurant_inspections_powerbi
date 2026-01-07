# Power Query – ETL Process

This document describes the ETL process implemented in **Power Query** to transform the original
DOHMH NYC Restaurant Inspection dataset into a structure suitable for analytical modeling in Power BI.

The ETL layer is intentionally **non-aggregating**: all business logic related to inspections,
scores, and risk indicators is delegated to the semantic layer (DAX).

---

## 1. Data source

The dataset is imported from a CSV file using:

- delimiter: `;`
- encoding: UTF-8
- explicit schema definition

An explicit schema is used to avoid implicit type inference and ensure deterministic transformations.

---

## 2. Column selection

Only columns required for analytical purposes are retained:

- CAMIS
- BORO
- CUISINE DESCRIPTION
- INSPECTION DATE
- VIOLATION CODE
- VIOLATION DESCRIPTION
- CRITICAL FLAG
- SCORE

This reduces model complexity and improves refresh performance.

---

## 3. Column renaming

Columns are renamed early to enforce semantic consistency across the model:

| Original name | Renamed column |
|--------------|----------------|
| CAMIS | restaurant_id |
| BORO | area_name |
| CUISINE DESCRIPTION | cuisine_desc |
| INSPECTION DATE | inspection_date |
| VIOLATION CODE | violation_code |
| VIOLATION DESCRIPTION | violation_desc |
| CRITICAL FLAG | critical_flag |
| SCORE | score_assigned |

---

## 4. Data typing

Explicit data types are assigned:

- restaurant_id → integer
- inspection_date → date
- score_assigned → integer

Explicit typing prevents silent conversion issues and aggregation anomalies.

---

## 5. Date key creation

A numeric date key `date_key` is created from `inspection_date`
using the format `YYYYMMDD`.

Invalid or placeholder dates (e.g. `1900-01-01`) are converted to `null`
as they do not represent valid inspection events.

The `date_key` is the sole link between the fact table and the time dimension.

---

## 6. Text normalization

The following normalization steps are applied:

- empty strings converted to `null`
- `Text.Trim` applied to all textual fields

This ensures consistency in joins, filtering, and deduplication logic.

---

## 7. Date dimension generation

From the distinct set of valid `date_key` values, a **date dimension** is generated.

The dimension includes:

- date_key
- full_date
- year
- quarter
- month_number
- month_name

This structure supports both chronological ordering and time-based aggregations,
including rolling window analysis.

---

## 8. Column removal and ordering

After generating `date_key`:

- the original `inspection_date` column is removed from the fact table
- columns are reordered to improve readability and logical grouping

---

## Methodological notes

- no rows are excluded during ETL
- inspection–violation granularity is preserved
- a single inspection may appear in multiple rows due to multiple violations
- no attempt is made in ETL to deduplicate inspections
- inspection reconstruction and aggregation logic is handled exclusively in DAX

This approach keeps the ETL layer transparent, stable, and easily auditable.
