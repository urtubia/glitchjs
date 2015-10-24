GameOfLife = require('./gameoflife.coffee')
GameOfLifePage = require('./glitchjs-ui/GameOfLifePage.coffee')
UI = require('./ui/UI.coffee')

class RootView extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @pages = []

class MainController
  constructor: ->
    @_cols = 26
    @_rows = 16
    @_gameOfLife = new GameOfLife(@_rows, @_cols)

class Application
  constructor: (canvas_div, @_width, @_height) ->
    @_canvas_div = canvas_div
    @_canvas_div.onmousedown = this.onMouseDown
    @_canvas_div.onmousemove = this.onMouseMove
    @_canvas_div.onmouseup = this.onMouseUp

    @_rootView = new RootView(new UI.Rectangle(0,0,@_width, @_height))
    @_initCanvasContext()

  getRootView: ->
    @_rootView

  onMouseDown: (evt) =>
    rect = @_canvas_div.getBoundingClientRect()
    x = evt.clientX - rect.left
    y = evt.clientY - rect.top

    @_rootView.mouseDown(x,y,x,y)

  onMouseMove: (evt) =>
    rect = @_canvas_div.getBoundingClientRect()
    x = evt.clientX - rect.left
    y = evt.clientY - rect.top

    @_rootView.mouseMove(x,y,x,y)

  onMouseUp: (evt) =>
    rect = @_canvas_div.getBoundingClientRect()
    x = evt.clientX - rect.left
    y = evt.clientY - rect.top

    @_rootView.mouseUp(x,y,x,y)

  draw: ->
    @_rootView.update(@_ctx)

  _initCanvasContext: ->
    @_canvas = document.createElement('canvas')
    @_canvas.setAttribute('width', @_width)
    @_canvas.setAttribute('height', @_height)
    @_canvas.setAttribute('id', 'canvas')
    @_canvas_div.appendChild(@_canvas)
    @_ctx = @_canvas.getContext("2d")

window.onload = ->
  canvas_div = document.getElementById "main_canvas"
  app = new Application(canvas_div, 800, 600)
  # TODO: this is a hack so that subviews can say window.application.draw()
  #       Fix plz!
  window.application = app
  mainController = new MainController()
  rootView = app.getRootView()
  gameOfLifePage = new GameOfLifePage(rootView.getBounds(), mainController)
  rootView.addSubView(gameOfLifePage)
  setInterval ->
    mainController._gameOfLife.advanceGeneration()
    app.draw()
  , 150


