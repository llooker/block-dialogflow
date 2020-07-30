#need to update

connection: "ccai_assisted_student"

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

explore: parsed_transcripts {
  sql_always_where: ${payload_type} = 'Dialogflow Response ' ;;
  join: parameters {
    view_label: "Custom Parameters"
    sql: LEFT JOIN UNNEST(${parsed_transcripts.parameters}) as parameters ;;
    relationship: one_to_one
  }
  join: session_facts {
    relationship: many_to_one
    sql_on: ${session_facts.session_id} = ${parsed_transcripts.session_id} ;;
  }
}
