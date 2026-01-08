# Power Query – ETL Process

This document describes the ETL process implemented in **Power Query**
to transform the original NYC DOHMH Restaurant Inspection dataset into a
clean, row-level dataset suitable for analytical modeling in Power BI.

The Power Query layer is intentionally **non-aggregating** and
**non-analytical**:
all inspection reconstruction, aggregation logic, and KPI definitions
are handled downstream in the dimensional model and DAX measures.

---

## 1. Data source

The dataset is imported from a raw CSV file provided by the
NYC Department of Health (DOHMH).

Import settings:
- delimiter: `,`
- encoding: UTF-8
- explicit schema definition via `TransformColumnTypes`

An explicit schema is applied to prevent implicit type inference
and ensure deterministic transformations.

---

## 2. Column selection

Only columns required for analytical modeling are retained:

- CAMIS
- DBA
- BORO
- CUISINE DESCRIPTION
- INSPECTION DATE
- ACTION
- VIOLATION CODE
- VIOLATION DESCRIPTION
- CRITICAL FLAG
- SCORE

This reduces model complexity and improves refresh performance,
while preserving the original inspection × violation grain.

---

## 3. Column renaming (canonical naming)

Columns are renamed early in the process to enforce semantic
consistency across SQL and Power BI projects.

| Original name | Canonical column |
|--------------|------------------|
| CAMIS | camis_code |
| DBA | establishment_name |
| BORO | area_name |
| CUISINE DESCRIPTION | cuisine_description |
| INSPECTION DATE | inspection_date |
| ACTION | action_taken |
| VIOLATION CODE | violation_code |
| VIOLATION DESCRIPTION | violation_description |
| CRITICAL FLAG | critical_flag |
| SCORE | score_assigned |

Canonical naming guarantees alignment with:
- `clean_data_table`
- dimension tables
- fact tables
- DAX measures

---

## 4. Data typing

Explicit data types are assigned:

- `camis_code` → text  
- `inspection_date` → date  
- `score_assigned` → integer  

All other attributes are treated as text and normalized accordingly.

Explicit typing avoids silent conversion issues
and ensures correct filtering and aggregation behavior in Power BI.

---

## 5. Invalid value handling

The following invalid or placeholder values are normalized to `null`:

- empty strings across all textual fields
- `"0"` used as a placeholder for `area_name`
- fake inspection date `"01/01/1900"`

Rows with null `inspection_date` are **retained** in the staging dataset
but are excluded from downstream fact tables due to the lack of a valid
inspection grain.

---

## 6. Text normalization

Textual attributes are standardized to ensure stable joins and filtering:

- `Text.Trim` applied to all text columns
- `Text.Upper` applied to:
  - `area_name`
  - `critical_flag`
- `Text.Proper` applied to:
  - `establishment_name`
  - `cuisine_description`

No semantic transformations are applied at this stage.

---

## 7. Grain preservation

The Power Query output preserves the **original source grain**:

**1 row = 1 violation recorded during an inspection**

Key implications:
- a single inspection may appear in multiple rows
- inspection-level uniqueness is not enforced
- no deduplication of inspection records is performed
- no inspection reconstruction logic is applied

This design choice ensures maximum transparency and auditability.

---

## 8. Date handling (important)

Power Query **does not generate a numeric date key**.

- `inspection_date` is preserved as a DATE field
- date surrogate keys are generated downstream (SQL or model layer)
- time intelligence logic is handled via the date dimension

This avoids duplication of date logic across tools and keeps
Power Query responsibilities minimal.

---

## Methodological notes

- No rows are aggregated or collapsed in Power Query
- No KPIs or analytical features are computed
- No inspection-level assumptions are introduced
- Inspection reconstruction and aggregation logic is handled
  exclusively in the dimensional model and DAX measures
- Power Query acts strictly as a **clean staging layer**

This separation ensures:
- consistency between SQL and Power BI projects
- easier validation of metrics
- clear ownership of analytical logic

*Back to the [README](README.md)*