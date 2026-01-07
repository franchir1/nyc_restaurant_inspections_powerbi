3. dax.md – DAX Measures (definitivo)
# DAX Formula Documentation

This document describes the final DAX measures used in the project.
All measures respect the logical inspection granularity
and are designed for decision-oriented analysis.

---

## Base measures

### BASE – Inspection Count

Counts distinct inspections using the reconstructed inspection identifier.

```DAX
BASE - Inspection Count =
DISTINCTCOUNT ( fact_inspections[inspection_business_key] )

BASE – Critical Inspection Count

Counts inspections with at least one critical violation.

BASE - Critical Inspection Count =
CALCULATE (
    [BASE - Inspection Count],
    fact_inspections[critical_flag] = "Critical"
)

BASE – Critical Inspection Rate
BASE - Critical Inspection Rate =
DIVIDE (
    [BASE - Critical Inspection Count],
    [BASE - Inspection Count]
)

BASE – Violation Count

Counts total recorded violations.

BASE - Violation Count =
COUNTROWS ( fact_inspections )

Score measures
SCORE – Average Inspection Score
SCORE - Average Inspection Score =
AVERAGEX (
    VALUES ( fact_inspections[inspection_business_key] ),
    CALCULATE ( MAX ( fact_inspections[score_assigned] ) )
)

Time measures (3-year rolling)

All rolling metrics use aggregated 3-year windows.

TIME – Inspection Count (3Y Rolling)
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

TIME – Inspection Score (3Y Rolling)
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

TIME – Critical Inspection Rate (3Y Rolling)
TIME - Critical Inspection Rate (3Y Rolling) =
VAR Inspections_3Y =
    CALCULATE (
        [BASE - Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= MAX ( date_dim[year] ) - 2
                && date_dim[year] <= MAX ( date_dim[year] )
        )
    )

VAR Critical_Inspections_3Y =
    CALCULATE (
        [BASE - Critical Inspection Count],
        FILTER (
            ALL ( date_dim[year] ),
            date_dim[year] >= MAX ( date_dim[year] ) - 2
                && date_dim[year] <= MAX ( date_dim[year] )
        )
    )

RETURN
DIVIDE ( Critical_Inspections_3Y, Inspections_3Y )

Methodological notes

all score aggregations respect inspection granularity

rolling windows are aggregated, not averaged

DIVIDE() is used to handle zero-denominator cases

measures are designed to work independently with field parameters