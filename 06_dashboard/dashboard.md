# Dashboard – NYC Restaurant Inspection Overview

This dashboard provides a structured analytical view of New York City restaurant health inspections, with the goal of assessing inspection volume, average quality, operational risk, and trends over time.

The analysis is built on a model with inspection–violation granularity; score-based aggregations are calculated at the true inspection level, reconstructed as the combination of restaurant and inspection date, avoiding duplication caused by multiple violations within a single inspection.

## Dashboard structure

The dashboard is organized into two main panels, each serving a distinct analytical role.

## Dashboard objective

The dashboard is designed to:

- identify structural patterns
- compare geographic areas and cuisine types
- observe improvement or deterioration trends over time
- support exploratory analysis through filters and contextual tooltips

## Main KPIs

KPIs are calculated within the active filter context (year and area):

- Inspection Count: total number of distinct inspections
- Average Inspection Score: average inspection score
- Critical Inspection Rate: percentage of inspections with at least one critical violation, used as an operational risk indicator

<p align="center">
  <img src="dashboard_overview.png" alt="Main dashboard" width="800">
</p>
<p align="center"><em>Main dashboard</em></p>

### Global filters

- time range (years)
- area / borough

All visuals react dynamically to the applied selections.

### KPI interpretation

**Average Inspection Score**

Average inspection scores are broadly stable over the analyzed period, with controlled values and consistent territorial differences.
The score represents average inspection quality, but does not measure the overall severity of violations.

**Critical Inspection Rate**

The rate of inspections with at least one critical violation is high, but shows a gradual reduction in recent years.
This metric measures the frequency of critical health risk, not its intensity.

**Inspection Count**

The number of inspections varies by geographic area and is proportional to population size and the number of venues.
The increase observed after 2021 is consistent with post-pandemic recovery and improved reporting processes.

### Cuisine rankings

The overview panel includes two rankings:

- Best Cuisine (Top 5): cuisine types with the lowest average score
- Worst Cuisine (Bottom 5): cuisine types with the highest average score

A dedicated tooltip provides additional context for each cuisine type, including average score and critical inspection rate.

**Interpretation**

The rankings show persistent differences across cuisine types over the medium term.
Higher scores suggest greater exposure to operational issues, without implying direct causality tied to cuisine type.

### Most recurring violation codes

The “Most Recurring Violation Codes” chart shows the most frequent violation codes in the dataset.

No one-to-one correlation is assumed between an individual violation code and the score.
The score is determined by the overall set of violations detected during the same inspection.

A dedicated tooltip provides code, description, and count.

**Interpretation**

Some violation codes are systematically more frequent, indicating recurring hygiene issues of a structural nature.
Frequency is not directly mappable to the score, which depends on the full combination of violations detected.

## 2. Time analysis

The second panel focuses on how indicators evolve over time.

### Selectable metrics

A field parameter allows analyzing three metrics through the same visual:

- Inspection Score (3Y Rolling)
- Critical Inspection Rate (3Y Rolling)
- Inspection Count (3Y Rolling)

Each metric should be interpreted independently.
The Y-axis adapts automatically to the selected measure context.

<p align="center">
  <img src="dashboard_trends.png" alt="Time analysis" width="800">
</p>
<p align="center"><em>Time analysis</em></p>

### 3-year rolling window

All time metrics use an aggregated 3-year rolling window, chosen to reduce annual volatility while remaining responsive to change.

For the Critical Inspection Rate, the metric can remain more volatile because it is a ratio between counts.
To preserve interpretability, longer windows or cumulative baselines are not used.

### Trend interpretation

**Average Inspection Score (3Y Rolling)**

The rolling score trend shows stable, controlled dynamics.
The rolling window reduces annual volatility without hiding potential structural changes.

**Critical Inspection Rate (3Y Rolling)**

The critical inspection rate shows a peak around 2021–2022 followed by a slow reduction.
Persistently high values suggest widespread risk with gradual improvement signals.

**Inspection Count (3Y Rolling)**

Inspection counts show progressive growth in recent years.
This dynamic is consistent with increased inspection activity rather than random variation.

## Key methodological choices

- scores are not cumulative over time; each inspection has an independent score
- a single inspection can include multiple violations, but only one score
- score aggregations are performed at the true inspection level (restaurant + date)
- the risk KPI is based on critical inspections, defined as inspections with at least one critical violation

*Back to the [README](/README.md)*
