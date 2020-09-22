connection: "@{CONNECTION_NAME}"

include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard"
include: "*.explore.lkml"
include: "//@{CONFIG_PROJECT_NAME}/*.view.lkml"
include: "//@{CONFIG_PROJECT_NAME}/*.model.lkml"
include: "//@{CONFIG_PROJECT_NAME}/*.dashboard"

explore: transcripts {
  extends: [transcripts_config]
}

explore: transcripts_core {
  extension: required
  sql_always_where: ${duration} is not null ;;
  join: transcripts__words {
    sql: ,UNNEST(transcripts.words) as transcripts__words ;;
    relationship: one_to_many
  }
  join: transcripts__entities {
    sql: ,unnest(transcripts.entities) as transcripts__entities ;;
    relationship: one_to_many
  }
  join: transcripts__sentences {
    sql: ,unnest(${transcripts.sentences}) as transcripts__sentences ;;
    relationship: one_to_many
  }

}
