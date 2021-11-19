include: "//@{CONFIG_PROJECT_NAME}/views/*"

###### CONTENT LAYER ######
view: parameters {
  extends: [parameters_config]
}


###### CORE LAYER ######
view: parameters_core {
  extension: required
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

  dimension: country {
    type: string
    sql: (SELECT json_extract_scalar(parameters, '$.value.string_value') from UNNEST([${TABLE}]) WHERE ${key} = 'geo-country');;
  }

}
