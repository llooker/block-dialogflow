project_name: "block-dialogflow"


################ Constants ################

constant: CONFIG_PROJECT_NAME {
  value: "block-dialogflow-config"
  export: override_required
}

constant: CONNECTION_NAME {
  value: "your_connection"
  export: override_required
}

constant: DATASET_NAME {
  value: "enter_your_dataset_here"
  export: override_required
}

################ Dependencies ################


local_dependency: {
  project: "@{CONFIG_PROJECT_NAME}"
}
