include: "//@{CONFIG_PROJECT_NAME}/transcripts.view.lkml"


view: transcripts {
  extends: [transcripts_config]
}

###################################################

view: transcripts_core {
  sql_table_name: @{DATASET_NAME}.insights_data_20200827 ;;

  set: drill_fields {
    fields: [call_date, conversation_name, audio_file_uri, agentid,duration,client_sentiment_score]
  }

  dimension: agentid {
    label: "Agent ID"
    type: string
    sql: ${TABLE}.agentid;;
  }

  dimension: conversation_name {
    primary_key: yes
    alias: [call_id]
    type: string
    sql: ${TABLE}.conversationname ;;
  }

  dimension: agent_sentiment_magnitude {
    type: number
    sql: ${TABLE}.agentSentimentMagnitude ;;
  }

  dimension: agent_sentiment_score {
    type: number
    sql: ${TABLE}.agentSentimentScore ;;
  }

  dimension: agent_speaking_percentage {
    value_format_name: percent_1
    type: number
    sql: ${TABLE}.agentspeakingpercentage ;;
  }

  dimension: client_sentiment_magnitude {
    type: number
    sql: ${TABLE}.clientSentimentMagnitude ;;
  }

  dimension: client_sentiment_score {
    type: number
    sql: ${TABLE}.clientSentimentScore ;;
  }

  dimension: client_speaking_percentage {
    value_format_name: percent_1
    type: number
    sql: ${TABLE}.clientspeakingpercentage ;;
  }

  dimension: client_sentiment_tier {
    type: tier
    tiers: [-1,0,0.2, 0.4, 0.6, 0.8, 1]
    style: relational
    sql: ${client_sentiment_score} ;;
  }

  dimension: agent_sentiment_tier {
    type: tier
    tiers: [-1,0,0.2, 0.4, 0.6, 0.8, 1]
    style: relational
    sql: ${agent_sentiment_score} ;;
  }

  measure: total_agent_speaking {
    type: sum
    sql: ${agent_speaking_percentage} * ${duration} ;;
    drill_fields: [drill_fields*]
  }

  measure: average_agent_speaking_percentage {
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

  measure: average_client_speaking_percentage {
    type: number
    sql: 1.0 * ${total_client_speaking} / ${total_duration};;
    value_format_name: percent_1
  }

  dimension: clientspeaking {
    label: "Client Speaking"
    type: number
    sql: ${client_speaking_percentage} * ${duration} ;;
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
    value_format_name: decimal_1
    description: "Seconds"
    type: number
    sql: ${TABLE}.durationnanos  / 1000000000;;
  }


  dimension: entities {
    hidden: yes
    sql: ${TABLE}.entities ;;
  }

  dimension: audio_file_uri {
    alias: [fileid]
    label: "File ID"
    type: string
    link: {
      label: "See Full Call Information"
      url: "https://contactcenterai.cloud.looker.com/dashboards-next/31?File%20ID={{ value | encode_url }}"
    }
    sql: ${TABLE}.audiofileuri ;;
  }

  dimension: filename {
    label: "File Name"
    type: string
    sql: ${TABLE}.audio_file_uri ;;
    link: {
      label: "Listen to Call"
      url: "https://drive.google.com/file/d/1kr2SUts5AsM8LjE3u-bs6jlos84v2DvD/view?usp=sharing"
      icon_url: "https://p7.hiclipart.com/preview/915/706/543/dialer-android-google-play-telephone-phone.jpg"
    }
  }

  dimension: audio_file {
    type: string
    sql: ${audio_file_uri} ;;
    html:
      <audio
        controls
        src="https://drive.google.com/file/d/1kr2SUts5AsM8LjE3u-bs6jlos84v2DvD/view?usp=sharing">
    </audio>
    ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  dimension: sentences {
    hidden: yes
    sql: ${TABLE}.sentences ;;
  }



  dimension: silencesecs {
    label: "Silence Seconds"
    value_format_name: decimal_0
    type: number
    sql: ${TABLE}.silencenanos / 1000000000 ;;
  }

  dimension: silence_percentage {
    type: number
    sql: ${TABLE}.silencePercentage ;;
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

  measure: average_client_sentiment_score{
    type: average
    sql: ${client_sentiment_score} ;;
    value_format_name: decimal_2
    drill_fields: [drill_fields*]
  }

  measure: average_agent_sentiment_score{
    type: average
    sql: ${agent_sentiment_score} ;;
    value_format_name: decimal_2
    drill_fields: [drill_fields*]
  }

  measure: total_call_volume {
    type: count_distinct
    sql: ${conversation_name} ;;
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
