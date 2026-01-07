# DAX Measures

## Overview

This document describes the **final DAX measures** used in the project.

All measures are designed to:

* respect inspection–violation granularity
* avoid score duplication bias
* produce stable, decision-oriented KPIs

All aggregation logic is intentionally implemented in DAX rather than in ETL.

---

## Measure design principles

* inspection scores aggregate only at the true inspection level
* violation metrics operate at fact-table row level
* reconstructed inspection identity is always enforced
* rolling windows are **aggregated**, not averaged
* measures are compatible with slicers and field parameters

---

## Base measures

### Inspection count

Counts distinct inspections using the reconstructed inspection identifier.

```DAX
BASE - Inspection Count =
DISTINCTCOUNT ( fact_inspections[inspection_business_key] )
```

---

### Critical inspection count

Counts inspections with at least one critical violation.

```DAX
BASE - Critical Inspection Count =
CALCULATE (
    [BASE - Inspection Count],
    fact_inspections[critical_flag] = "Critical"
)
```

---

### Critical inspection rate

Ratio of inspections with at least one critical violation.

```DAX
BASE - Critical Inspection Rate =
DIVIDE (
    [BASE - Critical Inspection Count],
    [BASE - Inspection Count]
)
```

---

### Violation count

Counts total recorded violations.

```DAX
BASE - Violation Count =
COUNTROWS ( fact_inspections )
```

---

## Score measures

### Average inspection score

Computes the average score across distinct inspections.

```DAX
SCORE - Average Inspection Score =
AVERAGEX (
    VALUES ( fact_inspections[inspection_business_key] ),
    CALCULATE ( MAX ( fact_inspections[score_assigned] ) )
)
```

This pattern guarantees that each inspection contributes exactly one score.

---

## Time-based measures (3-year rolling)

All time measures use **aggregated 3-year rolling windows**.

The rolling window is evaluated dynamically based on the selected year context.

---

### Inspection count (3Y rolling)

```DAX
TIME - Inspection Count (3Y Rolling) =
VAR curr_year = MAX ( date_dim[year] )
RETURN
CALCULATE (
    [BASE - Inspection Count],
    FILTER (
        ALL ( date_dim[year] ),
        date_dim[year] >= curr_year - 2
            && date_dim[year] <= curr_year
    )
)
```

---

### Average inspection score (3Y rolling)

```DAX
TIME - Inspection Score (3Y Rolling) =
VAR curr_year = MAX ( date_dim[year] )
RETURN
CALCULATE (
    [SCORE - Average Inspection Score],
    FILTER (
        ALL ( date_dim[year] ),
        date_dim[year] >= curr_year - 2
            && date_dim[year] <= curr_year
    )
)
```

---

### Critical inspection rate (3Y rolling)

```DAX
TIME - Critical Inspection Rate (3Y Rolling) =
VAR curr_year = MAX ( date_dim[year] )

VAR Inspections_3Y =
    CALCULATE (
        [BASE - Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= curr_year - 2
                && date_dim[year] <= curr_year
        )
    )

VAR Critical_Inspections_3Y =
    CALCULATE (
        [BASE - Critical Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= curr_year - 2
                && date_dim[year] <= curr_year
        )
    )

RETURN
DIVIDE ( Critical_Inspections_3Y, Inspections_3Y )
```

---

## Methodological notes

* all score aggregations enforce inspection-level granularity
* rolling metrics are aggregated over time windows
* `DIVIDE()` is used to handle zero-denominator cases
* measures are intentionally independent and composable

---

<figure align="center">
  <img src="star_scheme_PBI.png" alt="Star schema of the data model" width="700">
  <figcaption>Data model layout</figcaption>
</figure>

*Back to the [README](/README.md)*
