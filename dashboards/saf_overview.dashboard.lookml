- dashboard: saf_overview
  title: SAF Overview
  layout: newspaper
  preferred_viewer: dashboards
  elements:
  - title: Call Sentiment
    name: Call Sentiment
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.average_agent_sentiment_score]
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: google
      palette_id: google-categorical-0
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#4285F4",
        font_color: !!null '', color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 0
    col: 0
    width: 6
    height: 3
  - title: Call Breakdown
    name: Call Breakdown
    model: block_dialogflow
    explore: transcripts
    type: looker_donut_multiples
    fields: [transcripts.average_silence_percent]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: talk_time, label: Talk Time, expression: '1-${transcripts.average_silence_percent}',
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    series_types: {}
    listen:
      Agent ID: transcripts.agentid
    row: 0
    col: 17
    width: 7
    height: 6
  - title: Average Call Length
    name: Average Call Length
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.average_duration]
    limit: 500
    column_limit: 50
    listen:
      Agent ID: transcripts.agentid
    row: 0
    col: 12
    width: 5
    height: 3
  - title: Total Call Volume
    name: Total Call Volume
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.total_call_volume]
    limit: 500
    column_limit: 50
    listen:
      Agent ID: transcripts.agentid
    row: 3
    col: 12
    width: 5
    height: 3
  - title: Agent Speaking
    name: Agent Speaking
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.average_agent_speaking_percentage]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#EA4335",
        font_color: !!null '', color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 0
    col: 6
    width: 6
    height: 3
  - title: Client Speaking
    name: Client Speaking
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.average_client_speaking_percentage]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FFFFFF"
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#FBBC04",
        font_color: "#FFFFFF", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 3
    col: 0
    width: 6
    height: 3
  - title: Call Distribution
    name: Call Distribution
    model: block_dialogflow
    explore: transcripts
    type: looker_bar
    fields: [transcripts.average_client_speaking_percentage, transcripts.average_agent_speaking_percentage,
      transcripts.average_silence_percent]
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
    stacking: percent
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Agent ID: transcripts.agentid
    row: 6
    col: 0
    width: 24
    height: 5
  - title: Common Named Entities
    name: Common Named Entities
    model: block_dialogflow
    explore: transcripts
    type: looker_wordcloud
    fields: [transcripts.total_call_volume, transcripts__entities.name]
    filters:
      transcripts__entities.name: "-%Blue%,-%^ name%,-%bye-bye%"
    sorts: [transcripts.total_call_volume desc]
    limit: 10
    column_limit: 50
    color_application: undefined
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
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
    listen:
      Agent ID: transcripts.agentid
    row: 11
    col: 12
    width: 12
    height: 7
  - title: Call Log
    name: Call Log
    model: block_dialogflow
    explore: transcripts
    type: looker_grid
    fields: [transcripts.call_date, transcripts.audio_file_uri, transcripts.agentid,
      transcripts.total_duration, transcripts.average_client_speaking_percentage,
      transcripts.average_agent_speaking_percentage, transcripts.average_client_sentiment_score]
    sorts: [transcripts.audio_file_uri desc]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    series_types: {}
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 18
    col: 0
    width: 24
    height: 6
  - title: Average Call Duration by Hour of Day
    name: Average Call Duration by Hour of Day
    model: block_dialogflow
    explore: transcripts
    type: looker_column
    fields: [transcripts.average_duration, transcripts.total_call_volume, transcripts.call_hour_of_day]
    fill_fields: [transcripts.call_hour_of_day]
    sorts: [transcripts.call_hour_of_day]
    limit: 24
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
    point_style: circle_outline
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      transcripts.average_duration: "#39A736"
    show_null_points: true
    interpolation: linear
    hidden_fields: [transcripts.total_call_volume]
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 11
    col: 0
    width: 12
    height: 7
  - title: Silent Time
    name: Silent Time
    model: block_dialogflow
    explore: transcripts
    type: single_value
    fields: [transcripts.average_silence_percent]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#34A853",
        font_color: !!null '', color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      Agent ID: transcripts.agentid
    row: 3
    col: 6
    width: 6
    height: 3
  filters:
  - name: Agent ID
    title: Agent ID
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: block_dialogflow
    explore: transcripts
    listens_to_filters: []
    field: transcripts.agentid
