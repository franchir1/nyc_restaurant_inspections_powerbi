// ETL: raw_data -> clean_data
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
                {"CUISINE DESCRIPTION", "cuisine_type"},
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
                {"cuisine_type", type text},
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
                "cuisine_type",
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
                {"cuisine_type", Text.Trim},
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
                {"cuisine_type", Text.Proper},
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