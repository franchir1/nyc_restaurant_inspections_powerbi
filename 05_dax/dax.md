# DAX Formula Documentation

This document describes the final set of DAX measures used in the **NYC Restaurant Inspection Overview** dashboard.

Measures are organized by functional area and follow semantic definitions consistent with the data model and decision-oriented reporting goals.

## BASE Measures

### BASE - Inspection Count

Counts the total number of distinct inspections in the current filter context.
The count is computed at the true inspection level, reconstructed as the combination of restaurant and date.

```DAX
BASE - Inspection Count =
DISTINCTCOUNT ( fact_table[inspection_key] )
````

### BASE - Critical Inspection Count

Counts inspections that include at least one critical violation.
An inspection is considered critical if at least one associated violation is marked as critical.

```DAX
BASE - Critical Inspection Count =
CALCULATE (
    DISTINCTCOUNT ( fact_table[inspection_key] ),
    fact_table[critical_flag] = "Critical"
)
```

### BASE - Critical Inspection Rate

Calculates the percentage of critical inspections over total inspections.

```DAX
BASE - Critical Inspection Rate =
DIVIDE (
    [BASE - Critical Inspection Count],
    [BASE - Inspection Count]
)
```

### BASE - Violation Count

Counts the total number of recorded violations.
This measure operates at fact table row level and includes only rows with a populated violation.

```DAX
BASE - Violation Count =
CALCULATE (
    COUNTROWS ( fact_table ),
    NOT ISBLANK ( fact_table[violation_key] )
)
```

## SCORE Measures

### SCORE - Average Inspection Score

Calculates the average inspection score in the current filter context.
Null values are automatically ignored by the aggregation function.

```DAX
SCORE - Average Inspection Score =
AVERAGE ( fact_table[score] )
```

## TIME Measures (3-year rolling windows)

### TIME - Total Inspection (3Y Rolling)

Counts the total number of inspections over a rolling aggregated 3-year window
relative to the selected year.

```DAX
TIME - Total Inspection (3Y Rolling) =
CALCULATE (
    [BASE - Inspection Count],
    FILTER (
        ALL ( date_dim[year] ),
        date_dim[year] >= MAX ( date_dim[year] ) - 2
            && date_dim[year] <= MAX ( date_dim[year] )
    )
)
```

### TIME - Inspection Score (3Y Rolling)

Calculates the average inspection score over a rolling aggregated 3-year window.

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

### TIME - Critical Inspection Rate (3Y Rolling)

Calculates the aggregated rate of critical inspections over a rolling aggregated 3-year window.
The rate is defined as the ratio between total critical inspections
and total inspections in the same period.

```DAX
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
```

## Methodological notes

- all rolling metrics use an aggregated 3-year window, not an average of yearly rates
- `DIVIDE()` is used consistently to avoid division-by-zero errors
- inspection granularity is kept consistent across all measures
- measures are designed to be analyzed independently when used with Field Parameters
- `AVERAGE()` and `DISTINCTCOUNT()` correctly handle null values
- for `COUNTROWS()`-based metrics, explicit conditions are applied to exclude rows without an inspection identifier

*Back to the [README](/README.md)*
