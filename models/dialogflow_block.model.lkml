#need to update
connection: "@{CONNECTION_NAME}"

# include all the views
include: "//@{CONFIG_PROJECT_NAME}/*.model"
include: "//@{CONFIG_PROJECT_NAME}/views/*"
include: "/views/**/*.view"
include: "/explores/*"
include: "/dashboards/**/*.dashboard"



persist_with: default_datagroup

explore: parsed_transcripts {
  extends: [parsed_transcripts_config]
}
