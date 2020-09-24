#need to update
connection: "ccai_assisted_student"

# include all the views
include: "/views/**/*.view"
include: "/explores/*"
include: "//@{CONFIG_PROJECT_NAME}/*.model"
include: "//@{CONFIG_PROJECT_NAME}/views/*"
# include: "/dashboards/**/*.dashboard"



persist_with: default_datagroup

explore: parsed_transcripts {
  extends: [parsed_transcripts_config]
}
