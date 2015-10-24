GameOfLife = require('./gameoflife.coffee')
GameOfLifePage = require('./glitchjs-ui/GameOfLifePage.coffee')
UI = require('./ui/UI.coffee')

class RootView extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @pages = []
    @gameOfLifePage = new GameOfLifePage(rectangle, mainController)
    @_mainController = mainController
    this.addSubView(@gameOfLifePage)

class MainController
  constructor: ->
    @_cols = 26
    @_rows = 16
    @_gameOfLife = new GameOfLife(@_rows, @_cols)

class Application
  constructor: (canvas_div) ->
    @_canvas_div = canvas_div
    @_squareSide = 20
    @_padding = 1
    @_canvas_div.onmousedown = this.onMouseDown
    @_canvas_div.onmousemove = this.onMouseMove
    @_canvas_div.onmouseup = this.onMouseUp

    @_width = 800
    @_height = 600

    @_mainController = new MainController()
    @_rootView = new RootView(new UI.Rectangle(0,0,@_width, @_height), @_mainController)

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

  tick: =>
    @_mainController._gameOfLife.advanceGeneration()
    @_rootView.update(@_ctx)

  start: ->
    @_canvas = document.createElement('canvas')
    @_canvas.setAttribute('width', @_width)
    @_canvas.setAttribute('height', @_height)
    @_canvas.setAttribute('id', 'canvas')
    @_canvas_div.appendChild(@_canvas)
    @_ctx = @_canvas.getContext("2d")

    @_tick_timeout = setInterval(@tick, 150)


window.onload = ->
  canvas_div = document.getElementById "main_canvas"
  app = new Application(canvas_div)
  window.application = app
  app.start()


