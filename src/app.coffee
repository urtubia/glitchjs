GameOfLife = require('./gameoflife.coffee')
GameOfLifePage = require('./glitchjs-ui/GameOfLifePage.coffee')
UI = require('./ui/UI.coffee')

class MainController
  constructor: ->
    @_cols = 26
    @_rows = 16
    @_gameOfLife = new GameOfLife(@_cols, @_rows)
    # TODO this is a hack to allow the app to read the sequencer data 
    setTimeout =>
      for seqIdx in [0...6]
        seq = @_gameOfLife.sequencerAt seqIdx
        do (seqIdx, seq) ->
          seq.setTriggerCallback () ->
            console.log "Sequencer #{seqIdx} triggered"
    , 3000

    @_selectedPart = 0

  setSelectedPart: (selectedPart) ->
    @_selectedPart = selectedPart

  getSelectedPart: ->
    @_selectedPart

  toggleCell: (col, row) ->
    if @_selectedPart == 0
      @_gameOfLife.toggleAliveInSeed col, row
    else
      sequencer = @_gameOfLife.sequencerAt(@_selectedPart - 1)
      sequencer.toggleAlive col, row

window.onload = ->
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


