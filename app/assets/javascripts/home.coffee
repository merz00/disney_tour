item_hover_over = ($obj) ->
  id = $obj.data('attraction-id')
  $('#attraction-' + id + '-name').addClass('selected')
  $('#attraction-' + id + '-point').addClass('selected')

item_hover_out = ($obj) ->
  id = $obj.data('attraction-id')
  $('#attraction-' + id + '-name').removeClass('selected')
  $('#attraction-' + id + '-point').removeClass('selected')

item_clicked = ($obj) ->
  id = $obj.data('attraction-id')
  $('#attraction-' + id + '-name').addClass('decided')
  $('#attraction-' + id + '-point').addClass('decided')

  $('#attractions-form').append("<input type='hidden' name='attraction_ids[][" + id + "]' " +
      "value=" + 1 + ">")


$ ->
  $(".date-picker").datepicker();

  $('.attraction-label').hover(
    ->
      item_hover_over($(@))
    ->
      item_hover_out($(@))
  )

  $('.attraction-label').click(
    ->
      item_clicked($(@))
  )

  $('#opentime-label').click (
    ->
      $('#departed_hour   > option[value=08]').attr('selected', true)
      $('#departed_minute > option[value=00]').attr('selected', true)
  )