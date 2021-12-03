- dashboard: dialogflow
  preferred_viewer: dashboards-next
  title: Dialogflow Overview
  layout: newspaper
  filters:
    - name: Timestamp Date
      title: 'Date Range'
      type: date_filter
      default_value: 30 days

  elements:
  - title: Fallback Rate
    name: Fallback Rate
    model: dialogflow_block
    explore: parsed_transcripts
    type: single_value
    fields: [parsed_transcripts.fallback_rate]
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timestamp Date: parsed_transcripts.timestamp_date
    row: 17
    col: 10
    width: 6
    height: 4
  # - title: Total Chat Sessions
  #   name: Total Chat Sessions
  #   model: dialogflow_block
  #   explore: parsed_transcripts
  #   type: single_value
  #   fields: [parsed_transcripts.total_chat_sessions]
  #   limit: 500
  #   query_timezone: America/Los_Angeles
  #   custom_color_enabled: true
  #   show_single_value_title: true
  #   show_comparison: false
  #   comparison_type: value
  #   comparison_reverse_colors: false
  #   show_comparison_label: true
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   defaults_version: 1
  #   listen:
  #     Timestamp Date: parsed_transcripts.timestamp_date
  #   row: 0
  #   col: 4
  #   width: 5
  #   height: 5
  - title: Total Phone Users
    name: Total Phone Users
    model: dialogflow_block
    explore: parsed_transcripts
    type: single_value
    fields: [parsed_transcripts.total_telephone_users]
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timestamp Date: parsed_transcripts.timestamp_date
    row: 0
    col: 9
    width: 4
    height: 5
  - title: Top Area Codes
    name: Top Area Codes
    model: dialogflow_block
    explore: parsed_transcripts
    type: looker_pie
    fields: [parsed_transcripts.area_code, parsed_transcripts.count]
    filters:
      parsed_transcripts.area_code: "-NULL"
    sorts: [parsed_transcripts.area_code]
    limit: 500
    column_limit: 50
    value_labels: legend
    label_type: labPer
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    show_null_points: true
    interpolation: linear
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    listen:
      Timestamp Date: parsed_transcripts.timestamp_date
    row: 17
    col: 0
    width: 10
    height: 9
  - title: Total User Sessions
    name: Total User Sessions
    model: dialogflow_block
    explore: parsed_transcripts
    type: single_value
    fields: [parsed_transcripts.count_distinct_trace]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timestamp Date: parsed_transcripts.timestamp_date
    row: 0
    col: 0
    width: 4
    height: 5
  - title: Total Queries
    name: Total Queries
    model: dialogflow_block
    explore: parsed_transcripts
    type: single_value
    fields: [parsed_transcripts.count]
    filters:
      parsed_transcripts.resolved_query: "-NULL"
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Timestamp Date: parsed_transcripts.timestamp_date
    row: 0
    col: 13
    width: 5
    height: 5
  - title: Average Queries per Session
    name: Average Queries per Session
    model: dialogflow_block
    explore: parsed_transcripts
    type: single_value
    fields: [parsed_transcripts.count, parsed_transcripts.session_id]
    filters:
      parsed_transcripts.resolved_query: "-NULL"
    sorts: [parsed_transcripts.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: calculation_1, label: Calculation 1, expression: 'mean(${parsed_transcripts.count})',
        value_format: !!null '', value_format_name: decimal_2, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: [parsed_transcripts.count]
    listen: {}
    row: 0
    col: 18
    width: 6
    height: 5
  - title: Top User Phrases
    name: Top User Phrases
    model: dialogflow_block
    explore: parsed_transcripts
    type: looker_wordcloud
    fields: [parsed_transcripts.resolved_query, parsed_transcripts.count]
    filters:
      parsed_transcripts.resolved_query: -NULL,-"TELEPHONY_WARMUP",-"TELEPHONY_WELCOME",-WELCOME,-?,-"GOOGLE_ASSISTANT_WELCOME",-"HANGOUTS_WELCOME"
    sorts: [parsed_transcripts.resolved_query]
    limit: 500
    column_limit: 50
    color_application: undefined
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    up_color: "#3EB0D5"
    down_color: "#B1399E"
    total_color: "#C2DD67"
    groupBars: true
    labelSize: 10pt
    showLegend: true
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    font_size: 12
    listen: {}
    row: 5
    col: 13
    width: 11
    height: 12
  - title: Top Intents
    name: Top Intents
    model: dialogflow_block
    explore: parsed_transcripts
    type: looker_bar
    fields: [parsed_transcripts.intent_name, parsed_transcripts.count]
    filters:
      parsed_transcripts.intent_name: "-NULL,-Default Welcome Intent,-Default Fallback Intent"
    sorts: [parsed_transcripts.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_null_points: true
    interpolation: linear
    value_labels: legend
    label_type: labPer
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    color_application: undefined
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    up_color: "#3EB0D5"
    down_color: "#B1399E"
    total_color: "#C2DD67"
    truncate_column_names: false
    map: usa
    map_projection: ''
    quantize_colors: false
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    row: 5
    col: 0
    width: 13
    height: 12
