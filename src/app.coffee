$ = require('jquery')
UI = require('./ui/UI.coffee')
MainController = require('./MainController.coffee')
GameOfLifePage = require('./glitchjs-ui/GameOfLifePage.coffee')

initializeCanvasAndController = ->
  canvas_div = document.getElementById "main_canvas"
  app = new UI.Application(canvas_div, 800, 600)
  mainController = new MainController()
  rootView = app.getRootView()
  gameOfLifePage = new GameOfLifePage(new UI.Rectangle(0,0,rootView.getBounds().width, rootView.getBounds().height), mainController)
  rootView.addSubView(gameOfLifePage)
  setInterval ->
    mainController._gameOfLife.advanceGeneration()
    app.draw()
  , 150

window.tabClicked = (evt) ->
  if evt == 0
    $('#tab-sequencer').addClass('tab-selected')
    $('#tab-sample').removeClass('tab-selected')
    $('#sample-selection-page').hide()
  else if evt == 1
    $('#tab-sequencer').removeClass('tab-selected')
    $('#tab-sample').addClass('tab-selected')
    $('#sample-selection-page').show()

onWindowResize = ->
    width = $(window).width()
    console.log width
    $('#sample-selection-page').css('left', (width - 800)/2)

window.onload = ->
  initializeCanvasAndController()
  window.tabClicked(0)
  $(window).resize onWindowResize
  onWindowResize()

