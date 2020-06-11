#need to update

connection: "dialopgflow_bq"

# include all the views
include: "/views/**/*.view"
# include: "/dashboards/**/*.dashboard"

datagroup: default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: default_datagroup

explore: alpha {
  label: "Dialogflow Transcripts"
  view_label: "Dialogflow Transcripts"
}

explore: parsed_transcripts {}
