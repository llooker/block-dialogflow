- dashboard: single_call_log
  title: Single Call Log
  layout: newspaper
  elements:
  - title: Call Transcript
    name: Call Transcript
    model: call_demo_home
    explore: transcripts
    type: looker_grid
    fields: [transcripts.transcript]
    sorts: [transcripts.transcript]
    limit: 500
    column_limit: 50
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    size_to_fit: true
    series_text_format:
      transcripts.transcript:
        align: left
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      File ID: transcripts.fileid
    row: 12
    col: 0
    width: 10
    height: 8
  - title: Call Info
    name: Call Info
    model: call_demo_home
    explore: transcripts
    type: looker_single_record
    fields: [transcripts.agentid, transcripts.call_date]
    sorts: [transcripts.agentid]
    limit: 500
    column_limit: 50
    series_types: {}
    listen:
      File ID: transcripts.fileid
    row: 0
    col: 0
    width: 4
    height: 3
  - title: Total Call Duration Seconds
    name: Total Call Duration Seconds
    model: call_demo_home
    explore: transcripts
    type: single_value
    fields: [transcripts.total_duration]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: not null, value: !!null '', background_color: "#4285F4",
        font_color: !!null '', color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      File ID: transcripts.fileid
    row: 0
    col: 4
    width: 7
    height: 3
  - title: Conversation Trend
    name: Conversation Trend
    model: call_demo_home
    explore: transcripts
    type: looker_line
    fields: [transcripts__sentences.sentence, transcripts__sentences.total_score,
      transcripts__sentences.sentence_number]
    sorts: [transcripts__sentences.sentence_number]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: cumulative_sentiment_score, label: Cumulative
          Sentiment Score, expression: 'running_total(${transcripts__sentences.total_score})',
        value_format: !!null '', value_format_name: decimal_1, _kind_hint: measure,
        _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: circle
    series_point_styles: {}
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hidden_fields: [transcripts__sentences.total_score, transcripts__sentences.sentence_number]
    listen:
      File ID: transcripts.fileid
    row: 3
    col: 2
    width: 12
    height: 9
  - name: ''
    type: text
    body_text: Hover over points to see details of conversation.
    row: 3
    col: 0
    width: 2
    height: 9
  - title: Total Sentiment Score
    name: Total Sentiment Score
    model: call_demo_home
    explore: transcripts
    type: single_value
    fields: [transcripts__sentences.total_score]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: not null, value: 5, background_color: "#EA4335",
        font_color: "#FFFFFF", color_application: {collection_id: 9a6873a1-36c0-4c6d-bc31-af7d5793ad86,
          palette_id: 32d4aebe-a253-490b-bb8a-fa6f954952a7}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      File ID: transcripts.fileid
    row: 0
    col: 11
    width: 6
    height: 3
  - title: Silence Percent
    name: Silence Percent
    model: call_demo_home
    explore: transcripts
    type: single_value
    fields: [transcripts.average_silence_percent]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting: [{type: not null, value: 0.25, background_color: "#34A853",
        font_color: "#FFFFFF", color_application: {collection_id: 9a6873a1-36c0-4c6d-bc31-af7d5793ad86,
          palette_id: 32d4aebe-a253-490b-bb8a-fa6f954952a7}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      File ID: transcripts.fileid
    row: 0
    col: 17
    width: 7
    height: 3
  - title: Sentence Score Breakdown
    name: Sentence Score Breakdown
    model: call_demo_home
    explore: transcripts
    type: looker_bar
    fields: [transcripts__sentences.count_sentences, transcripts__sentences.score_tier]
    fill_fields: [transcripts__sentences.score_tier]
    limit: 500
    series_types: {}
    listen:
      File ID: transcripts.fileid
    row: 3
    col: 14
    width: 10
    height: 9
  - title: Common Entities
    name: Common Entities
    model: call_demo_home
    explore: transcripts
    type: looker_wordcloud
    fields: [transcripts__entities.name, transcripts.count]
    sorts: [transcripts.count desc]
    limit: 15
    column_limit: 50
    color_application: undefined
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    size_to_fit: true
    series_text_format:
      transcripts.transcript:
        align: left
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    hide_totals: false
    hide_row_totals: false
    defaults_version: 1
    listen:
      File ID: transcripts.fileid
    row: 12
    col: 10
    width: 14
    height: 8
  filters:
  - name: File ID
    title: File ID
    type: field_filter
    default_value: k327mjuj
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: call_demo_home
    explore: transcripts
    listens_to_filters: []
    field: transcripts.fileid
