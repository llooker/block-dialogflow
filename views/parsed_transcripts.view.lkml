view: parsed_transcripts {
  derived_table: {
    persist_for: "2 hours"
    #
    #
    sql:
    CREATE TEMP FUNCTION proto2json(prototext STRING, arrayKeys STRING)
      RETURNS STRING
      LANGUAGE js AS """

        /*TODO: maybe escape existing # in case it shows up in an unquoted key */

        /* Replace all strings with opaque reference to avoid matching inside them */
        var strings = []
        prototext = prototext.replace(
          /"([^"\\\\]*(\\\\.[^"\\\\]*)*)"/g,
          function(match){
            strings.push(match);
            return '#'+(strings.length-1)+' '
            }
          )

        /*Strip the leading type declaration*/
        prototext = prototext.replace(/^[A-za-z0-0 _]+\\s*:/,'');
        /* Add a colon between object key and abject */
        prototext = prototext.replace(/([a-zA-Z0-9_]+)\\s*\\{/g, function(match,m1){return m1+': {';});
        /* Add quotes around keys */
        prototext = prototext.replace(/([a-zA-Z0-9_]+):/g, function(match,m1){return '"'+m1+'" :';});
        /* Add commas between values */
        prototext = prototext.replace(/([0-9"}])\\s*\\n\\s*"/g, function(match,m1){return m1+' ,\\n "';});

        /* If array keys, take matching keys and prep them to not collapse */
        if(arrayKeys){
          if(arrayKeys && !arrayKeys.match(/^[A-Za-z0-9_]+(,[A-Za-z0-9_]+)*$/)){
            throw "Only [A-Za-z0-9_] array keys are currently supported, delimited by commas"
          }
          arrayKeys = arrayKeys.split(',')
          var arrayKeyRegex = new RegExp('"('+arrayKeys.join('|')+')"','g')
          var counter=0
          prototext = prototext.replace(arrayKeyRegex,function(match,key){
            counter++
            return '"'+key+'#'+counter+'"'
            })
          }

        /* Replace string references with their original values*/
        prototext = prototext.replace(
          /#(\\d+) /g,
          function(match,m1){
            return strings[parseInt(m1)]
            }
          )
        var jsonish = '{'+prototext+'}'

         if(!arrayKeys){return jsonish}
        var obj
        try{
          /* Parse jsonish, but replace all key#n entries with arrays*/
          obj = JSON.parse(jsonish, function(key,objValue){
            if(typeof objValue !== "object"){return objValue}
            var returnValue = {}
            var entries = Object.entries(objValue)
            /* Entries should already come out in lexicographical order, but if not we could sort here */
            for(let [entryKey,entryVal] of entries){
              let [groupKey,n] = entryKey.split('#')
              if(n===undefined){
                returnValue[entryKey] = entryVal
                }
              else{
                returnValue[groupKey] = (returnValue[groupKey]||[]).concat(entryVal)
              }
            }
            return returnValue
          })
        }
        catch(e){return "JSON Error! "+e+"\\n"+jsonish}
        return JSON.stringify(obj,undefined,1)
      """;
    SELECT
      textPayload as textPayload
      , proto2json(textPayload,"messages,fields") as payload_as_json
      FROM `covid-19-rrva-khwrml.rrva.transcripts`
      limit 1000
       ;;
  }

  dimension: id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.id') ;;
  }

  dimension: lang {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.lang') ;;
  }

  dimension_group: timestamp {
    type: time
    sql: cast(JSON_EXTRACT_SCALAR(${payload_as_json}, '$.timestamp')  as timestamp);;
  }

  dimension: session_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.session_id') ;;
  }

  #### Result Payload ####

  dimension: source {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.source') ;;
  }

  dimension: resolved_query {
    type: string
    sql:JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.resolved_query')  ;;
  }

  dimension: score {
    type: number
    sql:JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.score')  ;;
  }



  #### Metadata Payload

  dimension: webhook_for_slot_filling_used {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_for_slot_filling_used') = 'true' ;;

  }

  dimension: is_fallback_intent {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.is_fallback_intent') = 'true' ;;
  }

  dimension: intent_id {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_id') ;;
  }

  dimension: web_hook_response_time {
    type: number
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_response_time') ;;
  }

  dimension: intent_name {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.intent_name') ;;
  }

  dimension: intent_category {
    type: string
    sql: split(${intent_name}, '.')[OFFSET(0)];;
  }

  dimension: original_webhook_payload {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_payload') ;;
  }

  dimension: webhook_used {
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.webhook_used') = 'true' ;;
  }

  dimension: original_webhook_body {
    type: string
    sql: JSON_EXTRACT_SCALAR(${payload_as_json}, '$.result.metadata.original_webhook_body') ;;
  }

### Raw Data ###

  dimension: text_payload {
    type: string
    sql: ${TABLE}.textPayload ;;
  }

  dimension: payload_type {
    ### SQL Always Where in Model File is filtering data down to only Dialogflow Requests ###
    type: string
    sql: split(${text_payload}, ':')[OFFSET(0)];;
  }

  measure: count {
    description: "Raw Count of Total User Inputs - Includes Welcome Intent"
    type: count
    drill_fields: [detail*]
  }

  dimension: speech {
    type: string
    sql:replace(ltrim( ${TABLE}.speech, 'speech: '),"\"","") ;;
  }

  dimension: parameters {
    #Only used for unnesting join
    type: string
    hidden: yes
    sql:JSON_EXTRACT_ARRAY(${payload_as_json}, '$.result.parameters.fields')  ;;
  }

  dimension: parameters_as_string {
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





  dimension_group: receive_timestamp {
    type: time
    sql: cast(${TABLE}.receiveTimestamp as timestamp) ;;
  }

  dimension: result_source {
    type: string
    sql: ${TABLE}.result_source ;;
  }

  #### Missing Dimensions ####

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

#### Additional Metrics for Telephony Bots

  dimension: trace {
    view_label: "Missing"
    type: string
  }

  dimension: caller_id {
    view_label: "Missing"
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

view: parameters {
  dimension: key {
    type: string
    sql:  json_extract_scalar(parameters, '$.key') ;;
  }

  dimension: value {
    type: string
    sql:  json_extract_scalar(parameters, '$.value.string_value') ;;
  }

  parameter: parameter_selector {
    type: string
    suggest_dimension: parameters.key
  }

  dimension: dynamic_value {
    sql: (select ${value} from parameters where ${key} = 'covid-19')  ;;
  }


}
