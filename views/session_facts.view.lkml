# If necessary, uncomment the line below to include explore_source.
# include: "dialogflow.model.lkml"

view: session_facts {
  derived_table: {
    explore_source: parsed_transcripts {
      column: max_timestamp {}
      column: min_timestamp {}
      column: session_id {}
    }
  }
  dimension_group: max_timestamp {
    type: time
  }
  dimension_group: min_timestamp {
    type: time
  }
  dimension: session_duration {
    type: duration_second
    sql_start: ${min_timestamp_raw} ;;
    sql_end: ${max_timestamp_raw} ;;
  }

  dimension: session_duration_tiers {
    type: tier
    tiers: [0,10,30,120,560]
    sql: ${session_duration} ;;
  }

  measure: average_session_duration {
    type: average
    sql: ${session_duration};;
    value_format_name: decimal_1
  }

  measure: total_session_duration {
    type: sum
    sql: ${session_duration};;
    value_format_name: decimal_1
  }


  dimension: session_id {
    primary_key: yes
  }
}
