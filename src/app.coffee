GameOfLife = require('./gameoflife.coffee')
GameOfLifePage = require('./glitchjs-ui/GameOfLifePage.coffee')
UI = require('./ui/UI.coffee')

class MainController
  constructor: ->
    @_cols = 26
    @_rows = 16
    @_gameOfLife = new GameOfLife(@_rows, @_cols)

window.onload = ->
  canvas_div = document.getElementById "main_canvas"
  app = new UI.Application(canvas_div, 800, 600)
  mainController = new MainController()
  rootView = app.getRootView()
  gameOfLifePage = new GameOfLifePage(rootView.getBounds(), mainController)
  rootView.addSubView(gameOfLifePage)
  setInterval ->
    mainController._gameOfLife.advanceGeneration()
    app.draw()
  , 150


