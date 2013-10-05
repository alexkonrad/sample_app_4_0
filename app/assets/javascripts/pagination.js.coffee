$ ->
  alert "dom is loaded!"

$ ->
  $("#replies .pagination a").live "click", ->
    $.get @href,
      paginate: "received_replies",
      null, "script"
    false

  $("#messages .pagination a").live "click", ->
    $.get @href,
      paginate: "messages",
      null, "script"
    false

  $("#feed .pagination a").live "click", ->
    $.get @href,
      paginate: "feed",
      null, "script"
    false
