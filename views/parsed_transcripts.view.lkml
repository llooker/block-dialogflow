view: parsed_transcripts {
  derived_table: {
    persist_for: "2 hours"
    #
    #
    sql:
    CREATE TEMP FUNCTION proto2json(prototext STRING)
      RETURNS STRING
      LANGUAGE js AS """

        /*TODO: maybe escape existing $ */

        /* Replace all strings with opaque reference to avoid matching inside them */
        var strings = []
        prototext = prototext.replace(
          /"([^"\\\\]*(\\\\.[^"\\\\]*)*)"/g,
          function(match){
            strings.push(match);
            return '$'+(strings.length-1)+' '
            }
          )

        prototext = prototext.replace(/^[A-za-z0-0 _]+\\s*:/,'');

        prototext = prototext.replace(/([a-zA-Z0-9_]+)\\s*\\{/g, function(match,m1){return m1+': {';});




        prototext = prototext.replace(/([a-zA-Z0-9_]+):/g, function(match,m1){return '"'+m1+'" :';});


        prototext = prototext.replace(/([0-9"}])\\s*\\n\\s*"/g, function(match,m1){return m1+' ,\\n "';});

        /*TODO: take repeated key values and turn them into an array*/

        /* Replace string references with their original values*/
        prototext = prototext.replace(
          /\\$(\\d+) /g,
          function(match,m1){
            return strings[parseInt(m1)]
            }
          )
        return '{'+prototext+'}'
      """;
    SELECT
      textPayload as textPayload,
      regexp_extract(textPayload, r'string_value: .*') as string_value,
      regexp_extract(textPayload, r'speech: .*') as speech
      , proto2json(textPayload) as payload_as_json
      FROM `covid-19-rrva-khwrml.rrva.transcripts`
      limit 1000
       ;;
  }

  dimension: text_payload {
    type: string
    sql: ${TABLE}.textPayload ;;
  }

  measure: count {
    description: "Raw Count of Total User Inputs - Includes Welcome Intent"
    type: count
    drill_fields: [detail*]
  }

  dimension: payload_type {
    type: string
    sql: split(${text_payload}, ':')[OFFSET(0)];;
  }

  dimension: webhook_for_slot_filling_used {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_for_slot_filling_used') = 'true' ;;

  }

  dimension: is_fallback_intent {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.is_fallback_intent') = 'true' ;;

  }

  dimension: string_value {
    type: string
    sql:replace(ltrim( ${TABLE}.string_value, 'string_value: '),"\"","") ;;

  }

  dimension: speech {
    type: string
    sql:replace(ltrim( ${TABLE}.speech, 'speech: '),"\"","") ;;
  }

  dimension: session_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.session_id') ;;

  }

  dimension: score {
    type: number
    sql:JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.score')  ;;

  }

  dimension: resolved_query {
    type: string
    sql:JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.resolved_query')  ;;

  }

  dimension: parameters {
    type: string
    sql:JSON_EXTRACT(${payload_as_json}, '$.result.parameters.fields')  ;;

  }

  dimension: response_id {
    type: string
    sql:replace(ltrim( ${TABLE}.response_id, 'response_id: '),"\"","") ;;

  }

  dimension: payload_as_json {
    html: <div style="white-space:pre;max-width:640px;overflow:hidden">{{value}}</div> ;;
  }
  dimension: source {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.source') ;;
  }


  dimension: intent_name {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_name') ;;
  }

  dimension: intent_category {
    type: string
    sql: split(${intent_name}, '.')[OFFSET(0)];;
  }

  dimension: intent_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_id') ;;
  }

  dimension: web_hook_response_time {
    type: number
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_response_time') ;;
  }

  dimension: original_webhook_payload {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_payload') ;;
  }

  dimension: original_webhook_body {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_body') ;;
  }

  dimension: webhook_used {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_used') ;;
  }

  dimension: lang {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.lang') ;;
  }

  dimension_group: receive_timestamp {
    type: time
    sql: cast(${TABLE}.receiveTimestamp as timestamp) ;;
  }

  dimension: id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.id') ;;
  }

  dimension_group: timestamp {
    type: time
    sql: cast(JSON_EXTRACT_SCALAR(${payload_as_json}, '$.timestamp')  as timestamp);;
  }

  dimension: result_source {
    type: string
    sql: ${TABLE}.result_source ;;
  }


  #### Missing Dimensions ####

  dimension: trace {
    view_label: "Missing"
    type: string
  }

  dimension: caller_id {
    view_label: "Missing"
  }

  dimension: query_text {
    type: string
    sql:replace(ltrim( ${TABLE}.queryText, 'queryText: '),"\"","") ;;

  }

  dimension: is_user_query {
    type: yesno
    sql:  ;;
  }

  dimension: name {
    type: string
    sql:replace(ltrim( ${TABLE}.name, 'name: '),"\"","") ;;

  }

  measure: count_distinct_trace {
    type: count_distinct
    sql: ${trace} ;;
  }

  ##Below are Calculations From "Metrics to Measure" Google Doc

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

  dimension: area_code {
    view_label: "Missing"
    type: string
    sql: SUBSTR(${caller_id},2,3) ;;
  }

  measure: max_timestamp {
    type: date_time
    sql: MAX(${receive_timestamp_raw}) ;;
  }

  measure: min_timestamp {
    type: date_time
    sql: MIN(${receive_timestamp_raw}) ;;
  }

#
#   Total number of users
# *Skip



# Total number of user queries
# Count of rows per Session ID
# Total number of telephone users
# Count Distinct of Caller ID
# Successful intent rate
# Is Fallback Intent - Count of false/Total %
# Fallback rate
# Is Fallback Intent - Count of True/Total %
# What intent name occurs the most across all sessions?
# Intent Name and Session ID are metrics
# Per-channel access percentage
# *Skip
# Calling Geo (area code)
# Gotten from Caller ID based on first 3 numbers
# Repeat Users
# Not sure how because users get a new session ID every time they engage with the chatbot. Nothing persists unless they are using a platform where they are already authenticated.
# *Skip
# Total time spent on platform
# Relevant Fields are Session ID and Timestamp  - For each row in Session ID, subtract initial timestamp from final timestamp.
# Profanity - Not sure how to define
# *Skip
# Sentiment? - I think we need to enable it, I don’t see it in the logs


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
      is_fallback_intent,
      lang    ]
  }
}
