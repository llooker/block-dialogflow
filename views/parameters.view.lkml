view: parameters {
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
