# NYC Restaurant Inspections – Analytical Overview

This project analyzes health inspection data released by the
New York City Department of Health and Mental Hygiene (DOHMH).

The objective is to provide a **clear, stable, and decision-oriented view**
of how restaurant inspections behave over time, across geographic areas,
and across cuisine types.

---

## Why this project

Health inspection data is inherently complex:

- a single inspection may include multiple violations
- inspection scores are not cumulative
- raw data is granular and noisy

This project focuses on **analytical correctness**:
each KPI is designed to answer a precise question
without distortions caused by duplicated scores or mixed granularities.

---

## Analytical questions

The analysis addresses questions such as:

- How stable is the average inspection quality over time?
- How widespread is critical health risk?
- Are there persistent differences across boroughs?
- Do some cuisine types show systematically worse outcomes?
- Is the system improving, deteriorating, or remaining stable?

---

## Methodological approach

- raw data is cleaned and standardized using Power Query
- inspection–violation granularity is preserved
- inspection identity is reconstructed analytically
- all aggregations are handled in DAX
- time trends use rolling windows to reduce volatility

The model is designed to be **simple, auditable, and robust**.

---

## Dashboard structure

The dashboard is divided into two panels:

### Overview

Provides a snapshot of the system through:

- total inspections
- average inspection score
- critical inspection rate
- cuisine rankings
- most recurring violation codes

### Time analysis

Focuses on medium-term dynamics using 3-year rolling metrics:

- inspection volume
- average inspection score
- critical inspection rate

This separation allows both **instant assessment** and **trend interpretation**.

---

## Key takeaways

- Inspection quality is broadly stable, with persistent territorial differences
- Critical violations are widespread but show gradual improvement
- Some cuisine categories consistently exhibit higher operational risk
- Increased inspection activity after 2021 aligns with post-pandemic recovery

---

## Tools and skills

- Power Query for ETL
- Power BI and DAX for modeling and analytics
- star schema data modeling
- rolling window KPI design
- analytical documentation for portfolio presentation

---

This project is intended as a **portfolio case study**
and demonstrates an end-to-end analytical workflow
from raw data to decision-ready insights.
