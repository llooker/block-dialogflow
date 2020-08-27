#need to change this

connection: "call-home-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/view.lkml"                   # include all views in this project include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard
include: "/dashboards/*.dashboard"
# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: transcripts {
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
