English | [Italiano](/README.it.md)

# NYC Restaurant Inspections – Data Analysis with Power BI

This project analyzes the **Department of Health and Mental Hygiene (DOHMH)** dataset related to **health inspections of restaurants and university cafeterias** in New York City.

The project is designed as a **portfolio project** and represents the evolution of a previous SQL-based analysis.

## Dataset

The source dataset contains information on:

- health inspections
- inspection scores
- detected violations, including critical violations
- geographic area (borough)
- cuisine type
- inspection date

The dataset is provided in raw format and requires a cleaning and transformation process before being used in an analytical model.

## Project objective

The objective is to provide a **concise and stable** view of the health inspection system, answering key questions such as:

- What is the average inspection quality level?
- How widespread is critical health risk?
- Does the system show signs of structural improvement over time?
- Are there significant relationships between geographic areas and cuisine types?
- Which cuisine types show better or worse results?

The adopted approach is **KPI-driven** and oriented toward **decision support**.

## Data cleaning and transformation

The transformation process is fully implemented in **Power Query** and includes:

1. importing the original CSV file
2. selecting and renaming relevant columns
3. explicit data type assignment
4. null normalization and text cleaning
5. creation of an integer date key (`YYYYMMDD`)
6. preservation of inspection–violation granularity

No rows are excluded a priori. Aggregation and filtering logic is delegated to DAX measures.

The output is a **simplified star schema data model**, optimized for **performance, readability, and stability**.

## Data model

The model uses a star schema composed of a central **fact table** and related dimension tables for:
- time
- geographic area
- cuisine type
- restaurant
- violation type

The **actual inspection granularity** is reconstructed as a combination of restaurant and inspection date.

This choice is fundamental to:

- avoid score duplication due to multiple violations per inspection
- ensure correct metric aggregation
- maintain consistency between KPIs and time analysis

## Dashboard

The Power BI dashboard is divided into **two functional panels**, each dedicated to a different analytical level.

- The overview panel provides an immediate view of the system status through aggregated KPIs, cuisine rankings, and operational risk indicators.
- The time analysis panel focuses on KPI evolution over time using rolling averages for more stable interpretation.
- Metrics respond to global **year** and **geographic area** filters and use contextual tooltips.

## Methodological choices

- inspection scores are not cumulative over time; each inspection has an independent score
- a single inspection may include multiple violations, but only one overall score
- risk metrics are based on critical inspections, defined as inspections with at least one critical violation

## Key findings

- Average inspection quality is overall stable over time, with consistent territorial differences and controlled average scores.
- Critical health risk is widespread but shows a gradual reduction in recent years, suggesting possible structural improvement.
- Cuisine types display different medium-term patterns, with some categories systematically associated with higher average scores.

## Tools Used

- **Data cleaning:** Excel Power Query
- **Data modeling and visualization:** Power BI + DAX measures
- **IDE:** Visual Studio Code
- **Version control and documentation:** Git / GitHub

## Skills demonstrated

- star schema data modeling
- data cleaning and transformation in Power Query
- KPI and rolling metric development in DAX
- use of field parameters for dynamic analysis
- decision-oriented dashboard design
- structured technical documentation

## Technical documentation

- [Data cleaning and loading](03_power_query/power_query.md)
- [Data model](04_data_model/data_model.md)
- [DAX formulas](05_dax/dax.md)
- [Dashboard](06_dashboard/dashboard.md)
- *[Original dataset](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j/about_data)*
