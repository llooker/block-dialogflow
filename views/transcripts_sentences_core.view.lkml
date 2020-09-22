include: "//@{CONFIG_PROJECT_NAME}/transcripts_sentences.view.lkml"


view: transcripts_sentences {
  extends: [transcripts_sentences_config]
}

###################################################

view: transcripts_sentences_core {
  sql_table_name: @{DATASET_NAME}.insights_data_20200827 ;;

  dimension: end_offset_seconds {
    type: number
    sql: ${TABLE}.endOffsetNanos / 1000000000 ;;
  }

  dimension: start_offset_seconds {
    type: number
    sql: ${TABLE}.startOffsetNanos / 1000000000 ;;
  }

  dimension: time {
    datatype: epoch
    type: date_minute
    sql: cast(${end_offset_seconds} as int64) ;;
    drill_fields: [sentence, score, speaker_tag]
  }

  dimension: magnitude {
    type: number
    sql: ${TABLE}.magnitude ;;
  }

  dimension: sentence_number {
    type: number
    primary_key: yes
    sql: generate_uuid();;
  }

  dimension: speaker_tag {
    type: string
    sql: ${TABLE}.speakerTag ;;
  }

  dimension: speaker {
    type: string
    sql: case when ${speaker_tag} = 1 then 'Client' else 'Agent' End ;;
  }

  dimension: score {
    type: number
    sql: RAND() -.5 ;;
#     sql: ${TABLE}.sentimentScore ;;
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
