#include: "/models/dialogflow.model.lkml"

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
    label: "Session End"
    group_label: "Session End"
    description: "Time when session ended"
  }
  dimension_group: min_timestamp {
    type: time
    label: "Session Start"
    group_label: "Session Start"
    description: "Time when session started"
  }
  dimension: session_duration {
    label: "Session Duration (Seconds)"
    description: "Number of seconds from beginning to end of session"
    type: duration_second
    sql_start: ${min_timestamp_raw} ;;
    sql_end: ${max_timestamp_raw} ;;
    group_label: "Duration"
  }

  dimension: session_duration_tiers {
    label: "Session Duration Tier (Seconds)"
    description: "Tiers sessions based on number of seconds from beginning to end of session"
    type: tier
    tiers: [0,10,30,120,560]
    sql: ${session_duration} ;;
    group_label: "Duration"
  }

  dimension: session_duration_minutes {
    label: "Session Duration (Minutes)"
    description: "Number of Minutes from beginning to end of session"
    type: duration_minute
    sql_start: ${min_timestamp_raw} ;;
    sql_end: ${max_timestamp_raw} ;;
    group_label: "Duration"
  }

  dimension: session_duration_tiers_minutes {
    label: "Session Duration Tier (Minutes)"
    description: "Tiers sessions based on number of minutes from beginning to end of session"
    type: tier
    tiers: [1,2,5,10]
    sql: ${session_duration} ;;
    group_label: "Duration"
  }

  measure: average_session_duration {
    type: average
    label: "Average Session Duration (Seconds)"
    sql: ${session_duration};;
    value_format_name: decimal_1
    description: "Average length of session in number of seconds"
  }

  measure: total_session_duration {
    type: sum
    label: "Total Session Duration (Seconds)"
    sql: ${session_duration};;
    value_format_name: decimal_1
    description: "Total length of sessions in number of seconds"
  }


  dimension: session_id {
    primary_key: yes
  }
}
