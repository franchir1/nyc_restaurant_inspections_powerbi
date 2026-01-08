# DAX Measures

## Overview

This document describes the **final DAX measures** used in the project.

All measures are designed to:
- respect explicit analytical grains
- avoid inspection score duplication
- produce stable, decision-oriented KPIs
- remain fully consistent with the dimensional model

All aggregation logic is intentionally implemented in **DAX**, not in ETL.

---

## Measure Design Principles

- inspection scores aggregate only at **inspection grain**
- violation metrics operate at **inspection–violation grain**
- no inspection reconstruction logic is performed in DAX
- rolling windows are **aggregated**, not averaged
- measures are slicer-safe and compatible with field parameters
- fact tables are always aggregated before being combined

---

## Base Measures

### Inspection Count

Counts inspections at restaurant-day grain.

```DAX
BASE - Inspection Count =
COUNTROWS ( fact_inspection )
```

---

### Critical Inspection Count

Counts inspections with at least one critical violation.

```DAX
BASE - Critical Inspection Count =
CALCULATE (
    DISTINCTCOUNT ( fact_inspection_violation[inspection_key] ),
    fact_inspection_violation[critical_flag] = "CRITICAL"
)
```

---

### Critical Inspection Rate

Ratio of inspections with at least one critical violation.

```DAX
BASE - Critical Inspection Rate =
DIVIDE (
    [BASE - Critical Inspection Count],
    [BASE - Inspection Count]
)
```

---

### Violation Count

Counts inspection–violation pairs.

```DAX
BASE - Violation Count =
COUNTROWS ( fact_inspection_violation )
```

---

## Score Measures

### Average Inspection Score

Computes the average score across inspections.

```DAX
SCORE - Average Inspection Score =
AVERAGE ( fact_inspection[score_assigned] )
```

Because each inspection appears exactly once in `fact_inspection`,
no additional deduplication logic is required.

---

## Time-Based Measures (3-Year Rolling)

All time measures use **aggregated 3-year rolling windows**.
The rolling window is evaluated dynamically based on the selected year.

---

### Inspection Count (3Y Rolling)

```DAX
TIME - Inspection Count (3Y Rolling) =
VAR curr_year =
    MAX ( date_dim[inspection_year] )
RETURN
CALCULATE (
    [BASE - Inspection Count],
    FILTER (
        ALL ( date_dim[inspection_year] ),
        date_dim[inspection_year] >= curr_year - 2
            && date_dim[inspection_year] <= curr_year
    )
)
```

---

### Average Inspection Score (3Y Rolling)

```DAX
TIME - Average Inspection Score (3Y Rolling) =
VAR curr_year =
    MAX ( date_dim[inspection_year] )
RETURN
CALCULATE (
    [SCORE - Average Inspection Score],
    FILTER (
        ALL ( date_dim[inspection_year] ),
        date_dim[inspection_year] >= curr_year - 2
            && date_dim[inspection_year] <= curr_year
    )
)
```

---

### Critical Inspection Rate (3Y Rolling)

```DAX
TIME - Critical Inspection Rate (3Y Rolling) =
VAR curr_year =
    MAX ( date_dim[inspection_year] )

VAR Inspections_3Y =
    CALCULATE (
        [BASE - Inspection Count],
        FILTER (
            ALL ( date_dim[inspection_year] ),
            date_dim[inspection_year] >= curr_year - 2
                && date_dim[inspection_year] <= curr_year
        )
    )

VAR Critical_Inspections_3Y =
    CALCULATE (
        [BASE - Critical Inspection Count],
        FILTER (
            ALL ( date_dim[inspection_year] ),
            date_dim[inspection_year] >= curr_year - 2
                && date_dim[inspection_year] <= curr_year
        )
    )

RETURN
DIVIDE ( Critical_Inspections_3Y, Inspections_3Y )
```

---

## Cuisine-Based Ranking (Minimum Inspection Threshold)

When comparing cuisines, categories with very few inspections
produce unstable and misleading rankings.

To ensure analytical robustness, cuisine-level rankings are filtered
to include only cuisines with **at least 50 inspections**.

This prevents under-sampled cuisine types from appearing in leaderboards.

---

## Methodological Notes

* inspection-level aggregation is enforced structurally
* violation-level metrics use the bridge fact table
* rolling metrics are aggregated over time windows
* `DIVIDE()` is used to handle zero-denominator cases
* measures are intentionally independent and composable
* filtering logic is explicit and documented

---

*Back to the [README](/README.md)*