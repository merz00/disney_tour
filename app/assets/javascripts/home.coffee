item_hover_over = ($obj) ->
  id = $obj.data('attraction-id')
  area_id = $obj.data('area-id')

  $('#attraction-' + id + '-name').addClass('selected')
  $('#attraction-' + id + '-point').addClass('selected')

  $area_name = $('#area-' + area_id + '-name')
  $area_name.addClass('selected')
  $area_name.next().slideToggle() if $area_name.next().css('display') == 'none'

item_hover_out = ($obj) ->
  id = $obj.data('attraction-id')
  area_id = $obj.data('area-id')

  $('#attraction-' + id + '-name').removeClass('selected')
  $('#attraction-' + id + '-point').removeClass('selected')



item_clicked = ($obj) ->
  id = $obj.data('attraction-id')

  if $obj.hasClass('decided')
    $('#attraction-' + id + '-name').removeClass('decided')
    $('#attraction-' + id + '-point').removeClass('decided')
    $('#attraction-form-' + id).remove()

  else
    $('#attraction-' + id + '-name').addClass('decided')
    $('#attraction-' + id + '-point').addClass('decided')

    $('#attractions-form').append("<input type='hidden' class='attraction-select'" +
        "id='attraction-form-" + id + "' " +
        "name='attraction_ids[" + id + "]' " +
        "value=" + 1 + ">")

append_start_info = (data) ->
  $('#calc-results-start').empty()
  $('#calc-results-start').append(
      "<div class='start-time'>" + data.start_info.start_datetime + "</div>" +
      "<div class='attraction-name'>" + data.start_info.attraction_name + "</div>"
  )

append_attraciotns_info = (data) ->
  $('#calc-results-attractions').empty()
  $.each(data.attraction_infos,
    (i, attraction) ->
      $('#calc-results-attractions').append(
        "<div class='attraction'>" +
        "<div class='arrive-time'>" + attraction.arrive_time + "</div>" +
        "<div class='attraction-name'>" + attraction.attraction_name
        )
  )




$attraction_point = (id) ->
  $('#attraction-' + id + '-point')


pos_add = (pos1, pos2) ->
  left: pos1['left'] + pos2['left']
  top:  pos1['top']  + pos2['top']

pos_sub = (pos1, pos2) ->
  left: pos1.left - pos2.left
  top:  pos1.top  - pos2.top

pos_length = (pos) ->
  Math.sqrt(pos['left']**2 + pos['top']**2)

pos_mul = (pos , scala) ->
  left: pos['left']*scala
  top:  pos['top']*scala

pos_normalize = (pos) ->
  left: pos.left/pos_length(pos)
  top:  pos.top/pos_length(pos)


set_routes = (id1, id2) ->
  $point1 = $attraction_point(id1)
  $point2 = $attraction_point(id2)

  pos1 = $point1.position()
  pos2 = $point2.position()
  dir  = pos_normalize(pos_sub(pos2, pos1))

  pos = pos2
  len = 40
  max = pos_length(pos_sub(pos2, pos1))

  while len < max - 20
    pos = pos_add(pos1, pos_mul(dir, len))
    set_route_point(pos)
    len += 40


set_route_point = (pos) ->
  $route = $("<a class='route-sphere'></a>")
  $route.css('top',  pos['top'])
  $route.css('left', pos['left'])
  $('.attractions-map').append($route)

$ ->
  $(".date-picker").datepicker();
  window.setTimeout(
    ->
      $('.attraction-point').addClass('animation-target')
    300
  )
  window.setTimeout(
    ->
      $('.attraction-point').removeClass('animation-target')
    1300
  )

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
      $('.departed_hour').val("08:00")
  )


  $('#closetime-label').click (
    ->
      $('.finished_hour').val("22:00")
  )

  $('#attractions-form').submit (
    ->
      if $('#attractions-form .attraction-select').length > 0
        $.ajax(
          url: '/calc',
          type: 'POST',
          dataType: 'json',
          data: $(@).serializeArray(),
          timeout: 5000,
          success:
            (data) ->
              console.log(data)
              $('.tab-content').css('display', 'none')
              $('#search-result-tab').css('display', 'block')
              append_start_info(data)
              append_attraciotns_info(data)
          error:
            (data) ->
        )
      return false
  )

  $('.acMenu dt').click(
    ->
      $(this).next().slideToggle()
  );

  toTargetDigits = (num, digits) ->
    num += ''
    while num.length < digits
      num = '0' + num
    num

  date = new Date()
  hours = date.getHours()
  minutes = date.getMinutes()

  hh = toTargetDigits(hours, 2)
  MM = toTargetDigits(minutes, 2)
  $('.departed_hour').val(hh + ":" + MM)
  $('.finished_hour').val(hh + ":" + MM)


  $('#ui-tab li').click(
    ->
      $('.tab-content').css('display', 'none')
      $($(@).data('tab-content')).css('display', 'block')
  )

#  set_routes(1,2)
#  set_routes(2,4)
#  set_routes(4,14)
#  set_routes(14,26)
#  set_routes(26,34)

