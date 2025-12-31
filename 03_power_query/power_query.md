# Power Query – ETL Process

This section documents the ETL process implemented in **Power Query** starting from the original dataset provided by the Department of Health and Mental Hygiene (DOHMH).

The goal is to prepare the data for reporting in Power BI, preserving the original granularity and delegating aggregation logic to DAX measures.

## 1. Data source

The dataset is imported from a CSV file using:

- delimiter `;`
- UTF-8 encoding
- an explicit schema with 27 columns

Importing with a defined schema helps control data types and reduces ambiguity during transformation.

## 2. Column selection

Only the columns required by the final data model are kept:

- CAMIS
- BORO
- CUISINE DESCRIPTION
- INSPECTION DATE
- VIOLATION CODE
- VIOLATION DESCRIPTION
- CRITICAL FLAG
- SCORE

This selection reduces model complexity and improves overall performance.

## 3. Column renaming

Columns are renamed using semantic names consistent with the data model:

- CAMIS → restaurant_id
- BORO → area_name
- CUISINE DESCRIPTION → cuisine_desc
- INSPECTION DATE → inspection_date
- VIOLATION CODE → violation_code
- VIOLATION DESCRIPTION → violation_desc
- CRITICAL FLAG → critical_flag
- SCORE → score

Renaming early improves readability for both the model and DAX measures.

## 4. Field typing

Key fields are explicitly typed:

- restaurant_id as integer
- inspection_date as date
- score as integer

Explicit typing prevents implicit conversions and unexpected aggregation behaviors.

## 5. Date key creation (YYYYMMDD)

An integer key `date_key` in `YYYYMMDD` format is generated from `inspection_date`.

`null` values and the placeholder date `1900-01-01` are set to `null`, since they do not represent valid inspections for analytical purposes.

The `date_key` is used as the reference to the time dimension.

## 6. Null normalization and text cleaning

The following cleaning steps are applied:

- convert empty strings to `null`
- apply `Text.Trim` to text fields

These operations ensure consistency in joins, deduplication, and subsequent aggregations.

## 7. Column removal and reordering

After creating `date_key`:

- the `inspection_date` column is removed
- columns are reordered to improve fact table readability

## Methodological notes

- no rows are excluded a priori during the ETL process
- inspection–violation granularity is intentionally preserved
- reconstruction of the true inspection granularity (restaurant + date) is applied at the DAX level, not in ETL

This choice keeps the transformation process simple, transparent, and easily extensible.

*Back to the [README](/README.md)*
