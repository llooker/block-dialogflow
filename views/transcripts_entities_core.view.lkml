include: "//@{CONFIG_PROJECT_NAME}/transcripts_entities.view.lkml"


view: transcripts_entities {
  extends: [transcripts_entities_config]
}

###################################################

view: transcripts_entities_core {
  sql_table_name: @{DATASET_NAME}.insights_data_20200827 ;;

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
