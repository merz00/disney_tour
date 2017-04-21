item_over = ($obj) ->
  id = $obj.data('attraction-id')
  $('#attraction-' + id + '-name').addClass('selected')
  $('#attraction-' + id + '-point').addClass('selected')

item_out = ($obj) ->
  id = $obj.data('attraction-id')
  $('#attraction-' + id + '-name').removeClass('selected')
  $('#attraction-' + id + '-point').removeClass('selected')


$ ->
  $('.attraction-label').hover(
    ->
      item_over($(@))
    ->
      item_out($(@))
  )

  $('.attraction-name').hover(
    ->
      item_over($(@))
    ->
      item_out($(@))
  )