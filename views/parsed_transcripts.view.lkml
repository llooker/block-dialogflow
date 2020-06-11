view: parsed_transcripts {
  derived_table: {
    sql: SELECT
      regexp_extract(textPayload, r'webhook_used: .*') as webhook_used,

      regexp_extract(textPayload, r'webhook_for_slot_filling_used: .*') as webhook_for_slot_filling_used,

      regexp_extract(textPayload, r'string_value: .*') as string_value,

      regexp_extract(textPayload, r'speech: .*') as speech,

      regexp_extract(textPayload, r'source: .*') as source,

      regexp_extract(textPayload, r'session_id: .*') as session_id,

      regexp_extract(textPayload, r'score: .*') as score,
      regexp_extract(textPayload, r'resolved_query: .*') as resolved_query
      ,regexp_extract(textPayload, r'responseId": ".*') as response_id,
      regexp_extract(textPayload, r'queryText": ".*') as queryText,
      regexp_extract(textPayload, r'name": ".*') as name,
      regexp_extract(textPayload, r'intent_name: .*') as intent_name,
      regexp_extract(textPayload, r'intent_id: .*') as intent_id,
      regexp_extract(textPayload, r'code: .*') as code
      ,regexp_extract(textPayload, r'error_type: .*') as error_type
      ,regexp_extract(textPayload, r'is_fallback_intent: .*') as is_fallback_intent
      ,regexp_extract(textPayload, r'lang: .*') as lang
      ,regexp_extract(textPayload, r'timestamp: .*') as receiveTimestamp
      -- ,regexp_extract(textPayload, r'insertId: .*') as insertId
      -- ,regexp_extract(textPayload, r'logName: .*') as logName
      -- regexp_extract(textPayload, r'trace: .*') as trace,

      FROM `covid-19-rrva-khwrml.rrva.transcripts`
      limit 1000
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: webhook_used {
    type: string
    sql: ${TABLE}.webhook_used ;;
  }

  dimension: webhook_for_slot_filling_used {
    type: string
    sql: ${TABLE}.webhook_for_slot_filling_used ;;
  }

  dimension: string_value {
    type: string
    sql: ${TABLE}.string_value ;;
  }

  dimension: speech {
    type: string
    sql: ${TABLE}.speech ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: score {
    type: string
    sql: ${TABLE}.score ;;
  }

  dimension: resolved_query {
    type: string
    sql: ${TABLE}.resolved_query ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}.response_id ;;
  }

  dimension: query_text {
    type: string
    sql: ${TABLE}.queryText ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: intent_name {
    type: string
    sql: ${TABLE}.intent_name ;;
  }

  dimension: intent_id {
    type: string
    sql: ${TABLE}.intent_id ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: error_type {
    type: string
    sql:replace(ltrim( ${TABLE}.error_type, 'error_type:'),"\"","") ;;
  }

  dimension: is_fallback_intent {
    type: string
    sql: ${TABLE}.is_fallback_intent ;;
  }

  dimension: lang {
    type: string
    sql: ${TABLE}.lang ;;
  }

  dimension: receive_timestamp {
    type: string
    sql: ${TABLE}.receiveTimestamp ;;
  }

  set: detail {
    fields: [
      webhook_used,
      webhook_for_slot_filling_used,
      string_value,
      speech,
      source,
      session_id,
      score,
      resolved_query,
      response_id,
      query_text,
      name,
      intent_name,
      intent_id,
      code,
      error_type,
      is_fallback_intent,
      lang,
      receive_timestamp
    ]
  }
}
