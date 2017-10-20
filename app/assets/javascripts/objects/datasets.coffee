@downloadFile = (index,element) ->
  $('[data-object~="autodownload"]')[index].click()

@datasetsReady = ->
  $('[data-object~="autodownload"]').each((index, element) ->
    setTimeout((() -> downloadFile(index, element)), 500)
  )

$(document)
  .on('click', '[data-object~="toggle-page-list"]', ->
    $('.page-list-container').toggle()
    $('#show-page-button').toggle()
    $('#hide-page-button').toggle()
    $('#documentation-content').toggleClass('col-md-12 col-md-9')
    $('#sidebar-content').toggleClass('col-md-3')
    false
  )
  .on('click', '[data-object~="flip-card"]', ->
    $($(this).data('target')).toggleClass('dataset-card-flipped')
    if $($(this).data('target')).hasClass('dataset-card-flipped')
      $(this).html('details <i class="fa fa-caret-up text-muted"></i>')
    else
      $(this).html('details <i class="fa fa-caret-down text-muted"></i>')
    false
  )
