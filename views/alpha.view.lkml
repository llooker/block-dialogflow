view: alpha {
  sql_table_name: `rrva.transcripts`
    ;;

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: caller_id {
    type: string
    sql: ${TABLE}.caller_id ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: error_type {
    type: string
    sql: ${TABLE}.error_type ;;
  }

  dimension: insert_id {
    type: string
    sql: ${TABLE}.insertId ;;
  }

  dimension: intent_id {
    type: string
    sql: ${TABLE}.intent_id ;;
  }

  dimension: intent_name {
    type: string
    sql: ${TABLE}.intent_name ;;
  }

  dimension: is_fallback_intent {
    type: string
    sql: ${TABLE}.is_fallback_intent ;;
  }

  dimension: lang {
    type: string
    sql: ${TABLE}.lang ;;
  }

  dimension: log_name {
    type: string
    sql: ${TABLE}.logName ;;
  }

  dimension_group: receive_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.receiveTimestamp ;;
  }

  dimension: resolved_query {
    type: string
    sql: ${TABLE}.resolved_query ;;
  }

  dimension: score {
    type: string
    sql: ${TABLE}.score ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: speech {
    type: string
    sql: ${TABLE}.speech ;;
  }

  dimension: string_value {
    type: string
    sql: ${TABLE}.string_value ;;
  }

  dimension: text_payload {
    type: string
    sql: ${TABLE}.textPayload ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: trace {
    type: string
    sql: ${TABLE}.trace ;;
  }

  dimension: webhook_for_slot_filling_used {
    type: string
    sql: ${TABLE}.webhook_for_slot_filling_used ;;
  }

  dimension: webhook_used {
    type: string
    sql: ${TABLE}.webhook_used ;;
  }

  measure: count {
    type: count
    drill_fields: [intent_name, log_name,session_id]
  }

  measure: count_distinct_trace {
    type: count_distinct
    sql: ${trace} ;;
  }

  ##Below are Calculations From "Metrics to Measure" Google Doc

  measure: total_chat_sessions {
    type: count_distinct
    sql: ${session_id} ;;
    drill_fields: [session_id]
  }

  measure: total_telephone_users {
    type: count_distinct
    sql: ${caller_id} ;;
  }

  measure: total_intents {
    type: count_distinct
    sql: ${intent_name} ;;
  }

  measure: total_fallbacks {
    type: count
    filters:  {
      field: is_fallback_intent
      value: "true"
    }
  }

  measure: total_successful_intents {
    type: count
    filters:  {
      field: is_fallback_intent
      value: "false"
    }
  }

  measure: successful_intent_rate {
    type: number
    value_format_name: percent_2
    sql: ${total_successful_intents}/NULLIF(${count},0) ;;
  }

  measure: fallback_rate {
    type: number
    value_format_name: percent_2
    sql: ${total_fallbacks}/NULLIF(${count},0) ;;
  }

  dimension: area_code {
    type: string
    sql: SUBSTR(${caller_id},2,3) ;;
  }

  measure: max_timestamp {
    type: date_time
    sql: MAX(${timestamp_raw}) ;;
  }

  measure: min_timestamp {
    type: date_time
    sql: MIN(${timestamp_raw}) ;;
  }
}
