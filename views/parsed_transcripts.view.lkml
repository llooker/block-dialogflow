view: parsed_transcripts {
  derived_table: {
    sql:
    SELECT
      textPayload as textPayload
      , proto2json(textPayload,"messages,fields") as payload_as_json
      FROM `@{DATASET_NAME}.dialogflow_agent@{TABLE_PARTITION}`
       ;;
  }

  dimension: id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.id') ;;
    label: "Conversation ID"
    group_label: "IDs"
  }
  dimension: lang {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.lang') ;;
    label: "Language"
    description: "Language in which conversation took place"
    view_label: "Conversation Characteristics"
  }
  dimension_group: timestamp {
    type: time
    sql: cast(JSON_EXTRACT_SCALAR(${payload_as_json}, '$.timestamp')  as timestamp);;
    group_label: "Conversation Time"
    label: "Conversation Time"
    description: "Time when conversation occurred"
  }
  dimension: session_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.session_id') ;;
    group_label: "IDs"
  }

  #### Result Payload ####

  dimension: source {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.source') ;;
    view_label: "Conversation Characteristics"
    description: "Source of Conversation"
  }
  dimension: score_tier {
    type: tier
    sql: ${score} ;;
    style: interval
    tiers: [0.5,0.8,1]
  }
  dimension: resolved_query {
    description: "User Question / Message to bot"
    type: string
    sql:JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.resolved_query')  ;;
    label: "User Query"
  }
  dimension: score {
    type: number
    sql:CAST(JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.score') AS NUMERIC) ;;
    view_label: "Conversation Characteristics"
    description: "Score given to Conversation"
  }

  #### Metadata Payload

  dimension: webhook_for_slot_filling_used {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_for_slot_filling_used') = 'true' ;;
    view_label: "Conversation Characteristics"
  }
  dimension: is_fallback_intent {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.is_fallback_intent') = 'true' ;;
    description: "Whether the intent of the call was a fallback"
    view_label: "Conversation Characteristics"
  }
  dimension: intent_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_id') ;;
    group_label: "Intent"
    hidden: yes
  }
  dimension: web_hook_response_time {
    type: number
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_response_time') ;;
    view_label: "Conversation Characteristics"
  }
  dimension: response_time_tiers {

  }
  dimension: intent_name {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_name') ;;
    group_label: "Intent"
    description: "A description of the caller's intent"
    view_label: "Conversation Characteristics"
  }
  dimension: intent_category {
    type: string
    sql: split(${intent_name}, '.')[OFFSET(0)];;
    group_label: "Intent"
    drill_fields: [intent_name]
    description: "The category associated with the caller's intent"
    view_label: "Conversation Characteristics"
  }
  dimension: original_webhook_payload {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_payload') ;;
    group_label: "Original Webhook"
  }
  dimension: webhook_used {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_used') = 'true' ;;
    view_label: "Conversation Characteristics"
  }
  dimension: original_webhook_body {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_body') ;;
    group_label: "Original Webhook"
  }

### Fulfillment ####

  dimension: speech {
    description: "Bot Response"
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.fulfillment.speech') ;;
    label: "Bot Answer"
  }

### Raw Data ###

  dimension: text_payload {
    view_label: "Raw Data"
    type: string
    sql: ${TABLE}.textPayload ;;
  }
  dimension: payload_type {
    view_label: "Raw Data"
    ### SQL Always Where in Model File is filtering data down to only Dialogflow Requests ###
    type: string
    sql: split(${text_payload}, ':')[OFFSET(0)];;
  }
  dimension: parameters {
    #Only used for unnesting join
    type: string
    hidden: yes
    sql:JSON_EXTRACT_ARRAY(${payload_as_json}, '$.result.parameters.fields')  ;;
  }
  dimension: parameters_as_string {
    view_label: "Raw Data"
    type: string
    sql:JSON_EXTRACT(${payload_as_json}, '$.result.parameters.fields')  ;;
  }
  dimension: payload_as_json {

    view_label: "Raw Data"
    html: <div style="white-space:break-spaces;max-width:640px;overflow:hidden">{{value}}</div> ;;
  }

  ##Below are Calculations From "Metrics to Measure" Google Doc

  dimension: is_user_query {
    #Should be exclude any intents related to welcome messages
    type: yesno
    sql: ${intent_category} <> 'support' ;;
    view_label: "Conversation Characteristics"
    description: "Did the user submit a question?"
  }
  measure: count {
    description: "Raw Count of Total User Inputs - Includes Welcome Intent"
    type: count
    drill_fields: [detail*]
  }
  measure: total_sessions {
    type: count_distinct
    sql: ${session_id} ;;
    drill_fields: [session_id]
  }
  measure: queries_per_session {
    type: number
    sql: 1.0 * ${total_user_queries} / nullif(${total_sessions},0) ;;
    value_format_name: decimal_1
  }
  measure: distinct_intent_values {
    type: count_distinct
    sql: ${intent_name} ;;
  }
  measure: total_fallbacks {
    type: count
    filters:  {
      field: is_fallback_intent
      value: "yes"
    }
  }
  measure: total_successful_intents {
    type: count
    filters:  {
      field: is_fallback_intent
      value: "no"
    }
  }
  measure: total_user_queries {
    description: "Total number of user questions excluding introduction text."
    type: count
    ### Customize this filter to only include messages related to a customer question. ####
    filters: [intent_category: "-support"]
  }
  measure: successful_intent_rate {
    type: number
    value_format_name: percent_2
    sql: ${total_successful_intents}/NULLIF(${total_user_queries},0) ;;
  }
  measure: fallback_rate {
    type: number
    value_format_name: percent_2
    sql: ${total_fallbacks}/NULLIF(${count},0) ;;
  }
  measure: max_timestamp {
    hidden: yes
    type: date_time
    sql: MAX(${timestamp_raw}) ;;
  }
  measure: min_timestamp {
    hidden: yes
    type: date_time
    sql: MIN(${timestamp_raw}) ;;
  }

#### Additional Metrics for Telephony Bots

  dimension: trace {
    view_label: "Telephony Metrics"
    type: string
  }
  dimension: caller_id {
    view_label: "Telephony Metrics"
  }
  measure: count_distinct_trace {
    view_label: "Telephony Metrics"
    type: count_distinct
    sql: ${trace} ;;
  }
  measure: total_telephone_users {
    view_label: "Telephony Metrics"
    type: count_distinct
    sql: ${caller_id} ;;
  }
  dimension: area_code {
    view_label: "Telephony Metrics"
  }
  set: detail {
    fields: [
      webhook_used,
      webhook_for_slot_filling_used,
      speech,
      source,
      session_id,
      score,
      resolved_query,
      intent_name,
      intent_id,
      is_fallback_intent,
      lang    ]
  }
}
