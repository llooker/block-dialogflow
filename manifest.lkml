project_name: "block-dialogflow"


################ Constants ################

constant: CONFIG_PROJECT_NAME {
  value: "block-dialogflow-config"
  export: override_required
}

constant: CONNECTION_NAME {
  #value: "connection"
  value: "ccai_assisted_student"
  export: override_required
}

constant: DATASET_NAME {
  #value: "dataset"
  value: "insights_export_test"
  export: override_required
}

################ Dependencies ################


local_dependency: {
  project: "@{CONFIG_PROJECT_NAME}"
}
