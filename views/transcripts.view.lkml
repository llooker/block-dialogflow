view: transcripts {
  sql_table_name: safplaygrounddataset.transcripts ;;

  set: drill_fields {
    fields: [call_date, fileid, agentid,duration,sentimentscore]
  }

  dimension: agentid {
    label: "Agent ID"
    type: string
    sql: "";;
  }

  dimension: call_id {
    type: string
    sql: ${TABLE}.callid ;;
  }

#   dimension: primary_key {
#     type: string
#     sql: generate_UUID() ;;
#     primary_key: yes
#   }

  dimension: agentspeaking {
    label: "Agent Speaking"
    type: number
    sql: ${TABLE}.speakertwospeaking ;;
  }

  dimension: sentiment_tier {
    type: tier
    tiers: [-1,0,0.2, 0.4, 0.6, 0.8, 1]
    style: relational
    sql: ${sentimentscore} ;;
  }

  measure: total_agent_speaking {
    type: sum
    sql: ${agentspeaking} ;;
    drill_fields: [drill_fields*]
  }

  measure: average_agent_speaking {
    type: number
    sql: 1.0 * ${total_agent_speaking} / ${total_duration};;
    value_format_name: percent_1
    drill_fields: [drill_fields*]
  }


  measure: total_client_speaking {
    type: sum
    sql: ${clientspeaking} ;;
    drill_fields: [drill_fields*]
  }

  measure: average_client_speaking {
    type: number
    sql: 1.0 * ${total_client_speaking} / ${total_duration};;
    value_format_name: percent_1
  }

  dimension: clientspeaking {
    label: "Client Speaking"
    type: number
    sql: ${TABLE}.speakeronespeaking ;;
  }


  dimension: random {
    type: number
    sql: round(RAND()*10,0)  ;;
  }

  dimension_group: call {
    convert_tz: no
    datatype: timestamp
    type: time
    sql: PARSE_TIMESTAMP('%a %b %e %Y %T', 'Wed Jun 12 2019 18:46:00') ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}.day ;;
  }

  dimension: duration {
    type: number
    sql: cast(${TABLE}.duration as numeric);;
  }


  dimension: entities {
    hidden: yes
    sql: ${TABLE}.entities ;;
  }

  dimension: fileid {
    label: "File ID"
    type: string
    link: {
      label: "See Full Call Information"
      url: "https://contactcenterai.cloud.looker.com/dashboards-next/29?File%20ID={{ value | encode_url }}"
    }
    primary_key: yes
    sql: ${TABLE}.fileid ;;
  }

  dimension: filename {
    label: "File Name"
    type: string
    sql: ${TABLE}.filename ;;
    link: {
      label: "Listen to Call"
      url: "https://drive.google.com/file/d/1kr2SUts5AsM8LjE3u-bs6jlos84v2DvD/view?usp=sharing"
      icon_url: "https://p7.hiclipart.com/preview/915/706/543/dialer-android-google-play-telephone-phone.jpg"
    }
  }

  dimension: audio_file {
    type: string
    sql: ${filename} ;;
    html:
      <audio
        controls
        src="https://drive.google.com/file/d/1kr2SUts5AsM8LjE3u-bs6jlos84v2DvD/view?usp=sharing">
    </audio>
    ;;
  }

  dimension: magnitude {
    type: number
    sql: ${TABLE}.magnitude ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  dimension: nlcategory {
    label: "NL Category"
    type: string
    sql: ${TABLE}.nlcategory ;;
  }

  dimension: sentences {
    hidden: yes
    sql: ${TABLE}.sentences ;;
  }

  dimension: sentimentscore {
    label: "Sentiment Score"
    type: number
    sql: ${TABLE}.sentimentscore ;;
  }

  dimension: silencescore {
    label: "Silence Score"
    type: number
    sql: ${TABLE}.silencescore ;;
  }

  dimension: silencesecs {
    label: "Silence Seconds"
    value_format_name: decimal_0
    type: number
    sql: ${TABLE}.silencesecs ;;
  }

  dimension: silencevalue {
    label: "Silence Value"
    type: number
    sql: ${TABLE}.silencevalue ;;
  }

  dimension: starttime {
    label: "Start Time"
    type: string
    sql: ${TABLE}.starttime ;;
  }

  dimension: transcript {
    type: string
    sql: ${TABLE}.transcript ;;
  }

  dimension: words {
    hidden: yes
    sql: ${TABLE}.words ;;
  }

  measure: total_silence_time {
    type: sum
    sql: ${silencesecs} ;;
    drill_fields: [drill_fields*]
    value_format_name: decimal_1
  }



  measure: average_duration {
    type: average
    sql: ${duration} / 60 ;;
    html: {{rendered_value}} Min(s) ;;
    value_format_name: decimal_2
    drill_fields: [drill_fields*]
  }

  measure: average_silence_time {
    description: "This is average silent time"
    type: average
    sql: ${silencesecs} ;;
    value_format_name: decimal_1
    drill_fields: [drill_fields*]

  }

  measure: total_duration {
    type: sum
    sql: ${duration};;
    value_format_name: decimal_1
    drill_fields: [drill_fields*]
  }

  measure: average_silence_percent {
    type: number
    sql:1.0 * ${total_silence_time} / nullif(${total_duration}, 0);;
    value_format_name: percent_1
    drill_fields: [drill_fields*]
  }

  measure: average_sentiment_score{
    type: average
    sql: ${sentimentscore} ;;
    value_format_name: decimal_2
    drill_fields: [drill_fields*]
  }

  measure: total_call_volume {
    type: count_distinct
    sql: ${fileid} ;;
    drill_fields: [drill_fields*]
  }

  measure: total_client_speaking_time {
    type: sum
    sql: ${clientspeaking} ;;
    drill_fields: [drill_fields*]
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  measure: count {
    type: count
    drill_fields: [drill_fields*, filename]
  }
}

view: transcripts__sentences {


  dimension: magnitude {
    type: number
    sql: ${TABLE}.magnitude ;;
  }

  dimension: sentence_number {
    type: number
    primary_key: yes
    sql: generate_uuid();;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.sentiment ;;
  }

  dimension: score_tier {
    type: tier
    tiers: [-1,0,0.2, 0.4, 0.6, 0.8, 1]
    style: relational
    sql: ${score} ;;
  }

  measure: total_sentiment {
    type: sum
    sql: ${score} ;;
    value_format_name: decimal_0
  }

  measure: total_score {
    type: sum
    sql: ${score} ;;
    value_format_name: decimal_1

  }

  measure: count_sentences {
    type: count
  }

  dimension: sentence {
    type: string
    sql: ${TABLE}.sentence ;;
#     html:
#       {% assign var filter %}
#
#     {% for word in sentence %}
#             {{word}}
#       {% endfor %} ;;
  }
}

view: transcripts__words {
  dimension: confidence {
    type: number
    sql: ${TABLE}.confidence ;;
  }

  dimension: end_secs {
    type: number
    sql: ${TABLE}.endSecs ;;
  }

  dimension: speakertag {
    type: number
    sql: ${TABLE}.speakertag ;;
  }

  dimension: start_secs {
    type: number
    sql: ${TABLE}.startSecs ;;
  }

  dimension: word {
    primary_key: yes
    type: string
    sql: ${TABLE}.word ;;
  }
  measure: words {
    type: list
    list_field: word
  }

  measure: full_transcript {
    type: string
    sql: string_agg(${word}, ' ' order by ${start_secs}) ;;
  }
}

view: transcripts__entities {
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: sentiment {
    type: number
    sql: ${TABLE}.sentiment ;;
  }

  measure: average_sentiment {
    type: average
    sql:  ${sentiment}  ;;
    value_format_name: decimal_1
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
}
