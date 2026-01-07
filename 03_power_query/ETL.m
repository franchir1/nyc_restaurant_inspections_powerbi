// clean_data

let
    Source =
        Csv.Document(
            File.Contents("C:\Users\Lenovo\Desktop\DOHMH_New_York_City_Restaurant_Inspection_Results_20260104.csv"),
            [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.None]
        ),

    PromotedHeaders =
        Table.PromoteHeaders(
            Source,
            [PromoteAllScalars = true]
        ),

    NormalizedHeaders =
        Table.TransformColumnNames(
            PromotedHeaders,
            each Text.Trim(_)
        ),

    SelectedColumns =
        Table.SelectColumns(
            NormalizedHeaders,
            {
                "CAMIS",
                "DBA",
                "BORO",
                "CUISINE DESCRIPTION",
                "INSPECTION DATE",
                "ACTION",
                "VIOLATION CODE",
                "VIOLATION DESCRIPTION",
                "CRITICAL FLAG",
                "SCORE"
            }
        ),

    RenamedColumns =
        Table.RenameColumns(
            SelectedColumns,
            {
                {"CAMIS", "camis_code"},
                {"DBA", "establishment_name"},
                {"BORO", "area_name"},
                {"CUISINE DESCRIPTION", "cuisine_description"},
                {"INSPECTION DATE", "inspection_date"},
                {"ACTION", "action_taken"},
                {"VIOLATION CODE", "violation_code"},
                {"VIOLATION DESCRIPTION", "violation_description"},
                {"CRITICAL FLAG", "critical_flag"},
                {"SCORE", "score_assigned"}
            }
        ),

    ChangedTypes_Text =
        Table.TransformColumnTypes(
            RenamedColumns,
            {
                {"camis_code", type text},
                {"establishment_name", type text},
                {"area_name", type text},
                {"cuisine_description", type text},
                {"inspection_date", type text},
                {"action_taken", type text},
                {"violation_code", type text},
                {"violation_description", type text},
                {"critical_flag", type text},
                {"score_assigned", Int64.Type}
            },
            "en-US"
        ),

    ReplaceEmptyWithNull =
        Table.ReplaceValue(
            ChangedTypes_Text,
            "",
            null,
            Replacer.ReplaceValue,
            {
                "camis_code",
                "establishment_name",
                "area_name",
                "cuisine_description",
                "inspection_date",
                "action_taken",
                "violation_code",
                "violation_description",
                "critical_flag"
            }
        ),

    ReplaceZeroAreaWithNull =
        Table.ReplaceValue(
            ReplaceEmptyWithNull,
            "0",
            null,
            Replacer.ReplaceValue,
            {"area_name"}
        ),

    ReplaceFakeDateWithNull =
        Table.ReplaceValue(
            ReplaceZeroAreaWithNull,
            "01/01/1900",
            null,
            Replacer.ReplaceValue,
            {"inspection_date"}
        ),

    TrimText =
        Table.TransformColumns(
            ReplaceFakeDateWithNull,
            {
                {"camis_code", Text.Trim},
                {"establishment_name", Text.Trim},
                {"area_name", Text.Trim},
                {"cuisine_description", Text.Trim},
                {"inspection_date", Text.Trim},
                {"action_taken", Text.Trim},
                {"violation_code", Text.Trim},
                {"violation_description", Text.Trim},
                {"critical_flag", Text.Trim}
            }
        ),

    NormalizeText =
        Table.TransformColumns(
            TrimText,
            {
                {"establishment_name", Text.Proper},
                {"area_name", Text.Upper},
                {"cuisine_description", Text.Proper},
                {"critical_flag", Text.Upper}
            }
        ),

    AddDateKey =
        Table.AddColumn(
            NormalizeText,
            "date_key",
            each
                if [inspection_date] = null then
                    null
                else
                    Date.Year(Date.FromText([inspection_date], "en-US")) * 10000
                        + Date.Month(Date.FromText([inspection_date], "en-US")) * 100
                        + Date.Day(Date.FromText([inspection_date], "en-US")),
            Int64.Type
        ),

    ConvertInspectionDate =
        Table.TransformColumnTypes(
            AddDateKey,
            {{"inspection_date", type date}},
            "en-US"
        )
in
    ConvertInspectionDate


    // date_dim

let
    Source = clean_data,

    SelectDate =
        Table.SelectColumns(
            Source,
            {"date_key"}
        ),

    RemoveNulls =
        Table.SelectRows(
            SelectDate,
            each [date_key] <> null
        ),

    RemoveDuplicates =
        Table.Distinct(RemoveNulls),

    AddDate =
        Table.AddColumn(
            RemoveDuplicates,
            "date",
            each
                Date.FromText(
                    Text.Start(Text.From([date_key]), 4) & "-"
                    & Text.Middle(Text.From([date_key]), 4, 2) & "-"
                    & Text.End(Text.From([date_key]), 2)
                ),
            type date
        ),

    AddYear =
        Table.AddColumn(
            AddDate,
            "year",
            each Date.Year([date]),
            Int64.Type
        ),

    AddMonth =
        Table.AddColumn(
            AddYear,
            "month",
            each Date.Month([date]),
            Int64.Type
        ),

    AddMonthName =
        Table.AddColumn(
            AddMonth,
            "month_name",
            each Date.MonthName([date]),
            type text
        ),

    AddQuarter =
        Table.AddColumn(
            AddMonthName,
            "quarter",
            each "Q" & Text.From(Date.QuarterOfYear([date])),
            type text
        ),

    AddDay =
        Table.AddColumn(
            AddQuarter,
            "day",
            each Date.Day([date]),
            Int64.Type
        ),

    AddWeekday =
        Table.AddColumn(
            AddDay,
            "weekday",
            each Date.DayOfWeek([date], Day.Monday) + 1,
            Int64.Type
        ),

    AddWeekdayName =
        Table.AddColumn(
            AddWeekday,
            "weekday_name",
            each Date.DayOfWeekName([date]),
            type text
        ),

    ReorderColumns =
        Table.ReorderColumns(
            AddWeekdayName,
            {
                "date_key",
                "date",
                "year",
                "quarter",
                "month",
                "month_name",
                "day",
                "weekday",
                "weekday_name"
            }
        )
in
    ReorderColumns


// area_dim

let
    Source = clean_data,

    SelectColumns =
        Table.SelectColumns(
            Source,
            {"area_name"}
        ),

    RemoveNulls =
        Table.SelectRows(
            SelectColumns,
            each [area_name] <> null
        ),

    RemoveDuplicates =
        Table.Distinct(
            RemoveNulls,
            {"area_name"}
        ),

    AddAreaKey =
        Table.AddIndexColumn(
            RemoveDuplicates,
            "area_key",
            1,
            1,
            Int64.Type
        ),

    ReorderColumns =
        Table.ReorderColumns(
            AddAreaKey,
            {
                "area_key",
                "area_name"
            }
        )
in
    ReorderColumns

// establishment_dim

let
    Source = clean_data,

    SelectColumns =
        Table.SelectColumns(
            Source,
            {
                "camis_code",
                "establishment_name",
                "cuisine_description"
            }
        ),

    RemoveNulls =
        Table.SelectRows(
            SelectColumns,
            each [camis_code] <> null
        ),

    RemoveDuplicates =
        Table.Distinct(
            RemoveNulls,
            {"camis_code"}
        ),

    AddEstablishmentKey =
        Table.AddIndexColumn(
            RemoveDuplicates,
            "establishment_key",
            1,
            1,
            Int64.Type
        ),

    ReorderColumns =
        Table.ReorderColumns(
            AddEstablishmentKey,
            {
                "establishment_key",
                "camis_code",
                "establishment_name",
                "cuisine_description"
            }
        )
in
    ReorderColumns


// violation_dim

let
    Source = clean_data,

    SelectColumns =
        Table.SelectColumns(
            Source,
            {"violation_code", "violation_description"}
        ),

    RemoveNulls =
        Table.SelectRows(
            SelectColumns,
            each [violation_code] <> null
        ),

    RemoveDuplicates =
        Table.Distinct(
            RemoveNulls,
            {"violation_code"}
        ),

    AddViolationKey =
        Table.AddIndexColumn(
            RemoveDuplicates,
            "violation_key",
            1,
            1,
            Int64.Type
        ),

    ReorderColumns =
        Table.ReorderColumns(
            AddViolationKey,
            {
                "violation_key",
                "violation_code",
                "violation_description"
            }
        )
in
    ReorderColumns

// fact_inspection

let
    Source = clean_data,

    CleanText =
        Table.TransformColumns(
            Table.SelectColumns(
                Source,
                {
                    "camis_code",
                    "area_name",
                    "date_key",
                    "score_assigned",
                    "action_taken",
                    "violation_code",
                    "critical_flag"
                }
            ),
            {
                {"camis_code", Text.Trim},
                {"area_name", Text.Upper},
                {"violation_code", Text.Trim},
                {"critical_flag", Text.Upper}
            }
        ),

    NormalizeActionTaken =
        Table.TransformColumns(
            CleanText,
            {
                {
                    "action_taken",
                    each
                        if _ = "Violations were cited in the following area(s)." then
                            "Violations cited."
                        else if _ = "No violations were recorded at the time of this inspection." then
                            "No violations recorded."
                        else if _ = "Establishment re-opened by DOHMH." then
                            "Establishment re-opened."
                        else if _ = "Establishment Closed by DOHMH. Violations were cited in the following area(s) and those requiring immediate action were addressed." then
                            "Establishment Closed. Violations cited."
                        else if _ = "Establishment re-closed by DOHMH." then
                            "Establishment re-closed."
                        else
                            Text.Trim(_),
                    type text
                }
            }
        ),

    AddInspectionBusinessKey =
        Table.AddColumn(
            NormalizeActionTaken,
            "inspection_business_key",
            each
                Text.From([camis_code]) & "|"
                & Text.From([date_key]) & "|"
                & Text.From([action_taken]) & "|"
                & Text.From([score_assigned]),
            type text
        ),

    ExpandEstablishment =
        Table.ExpandTableColumn(
            Table.NestedJoin(
                AddInspectionBusinessKey,
                "camis_code",
                establishment_dim,
                "camis_code",
                "est",
                JoinKind.LeftOuter
            ),
            "est",
            {"establishment_key"}
        ),

    ExpandArea =
        Table.ExpandTableColumn(
            Table.NestedJoin(
                ExpandEstablishment,
                "area_name",
                area_dim,
                "area_name",
                "area",
                JoinKind.LeftOuter
            ),
            "area",
            {"area_key"}
        ),

    ExpandViolation =
        Table.ExpandTableColumn(
            Table.NestedJoin(
                ExpandArea,
                "violation_code",
                violation_dim,
                "violation_code",
                "viol",
                JoinKind.LeftOuter
            ),
            "viol",
            {"violation_key"}
        ),

    ExpandDate =
        Table.ExpandTableColumn(
            Table.NestedJoin(
                ExpandViolation,
                "date_key",
                date_dim,
                "date_key",
                "dt",
                JoinKind.LeftOuter
            ),
            "dt",
            {}
        ),

    RemoveNaturalKeys =
        Table.RemoveColumns(
            ExpandDate,
            {
                "camis_code",
                "area_name",
                "violation_code"
            }
        ),

    AddInspectionKey =
        Table.AddIndexColumn(
            RemoveNaturalKeys,
            "inspection_key",
            1,
            1,
            Int64.Type
        ),

    ReorderColumns =
        Table.ReorderColumns(
            AddInspectionKey,
            {
                "inspection_key",
                "inspection_business_key",
                "date_key",
                "establishment_key",
                "area_key",
                "violation_key",
                "critical_flag",
                "score_assigned",
                "action_taken"
            }
        )
in
    ReorderColumns

