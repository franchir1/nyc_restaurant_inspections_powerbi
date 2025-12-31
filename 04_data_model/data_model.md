# Data model

The project uses a **simplified star schema data model**, designed to support aggregated KPIs, comparative analyses, and time trends in Power BI, while maintaining **semantic clarity and strong performance**.

The model is intentionally compact and focused on **decision-oriented reporting**, not detailed transactional analysis.

## Fact table

### fact_inspections

The fact table contains restaurant health inspection results and the violations detected during each inspection.

| Field | Description |
| --- | --- |
| inspection_key | Technical row key (surrogate key, not an inspection identifier) |
| date_key | Key to the time dimension `date_dim` |
| restaurant_key | Key to `restaurant_dim` |
| area_key | Key to `area_dim` |
| cuisine_key | Key to `cuisine_dim` |
| violation_key | Key to `violation_dim` |
| score | Score assigned to the inspection |
| has_critical_violation | Flag indicating the presence of at least one critical violation |

### Data granularity

Each row in the fact table **does not represent a unique inspection**, but rather a **violation recorded during an inspection**.

Specifically:

- a single inspection is identified by the combination of restaurant and inspection date
- a single inspection can generate multiple rows in the fact table
- the score is unique per inspection, but repeated across all rows associated with the detected violations

The **true inspection granularity** is therefore defined as the combination of:

```
restaurant_key + date_key
```

Logically, the inspection identifier can be reconstructed as:

```m
Text.From([restaurant_key]) & "_" & Text.From([date_key])
```

This choice makes it possible to:

- avoid score duplication due to multiple violations in the same inspection
- uniquely identify each inspection event
- automatically exclude from aggregations rows without a restaurant or date

### Critical violations

The `has_critical_violation` flag indicates the presence of at least one violation coded as critical in the dataset.

The model does not include narrative closure events or free-text notes and focuses exclusively on **structured codes**, consistent with a quantitative and comparative analysis goal.

## Dimensions

### date_dim

| Field | Description |
| --- | --- |
| date_key | Date key in YYYYMMDD format |
| year | Year |

The time dimension uses an **integer YYYYMMDD key**, chosen to ensure:

- natural chronological ordering
- more efficient joins
- model simplicity and stability

This structure is fully adequate for the intended time analyses.

### area_dim

| Field | Description |
| --- | --- |
| area_key | Area identifier |
| area_name | Area name |

### cuisine_dim

| Field | Description |
| --- | --- |
| cuisine_key | Cuisine identifier |
| cuisine_type | Cuisine type |

### restaurant_dim

| Field | Description |
| --- | --- |
| restaurant_key | Restaurant technical key |
| restaurant_id | Original identifier (CAMIS) |

The restaurant dimension supports venues with **multiple inspections over time**, keeping restaurant identity separate from the inspection event.

### violation_dim

| Field | Description |
| :--- | :--- |
| violation_key | Violation technical key |
| violation_code | Violation code |
| violation_description | Text description of the violation |

`violation_description` is not used for KPIs or aggregations, as it is non-standardized free text.
Analyses rely exclusively on **violation codes**.

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

- model simplicity
- predictable filter behavior
- better calculation performance

## Key methodological choices

- score-based metrics always aggregate at the true inspection level
- violation-based metrics operate at the fact table row level
- separation between operational KPIs and descriptive metrics is intentional
- the model prioritizes readability and stability over extreme normalization

*Back to the [README](/README.md)*
