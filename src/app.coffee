GameOfLife = require("./gameoflife.coffee")
UI = require("./UI.coffee")

class GenerationSliderControl extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController

  draw: (context) ->
    width = @rectangle.width
    height = @rectangle.height
    gameOfLife = @_mainController._gameOfLife
    xDelta = (width / 32.0) - 2

    for i in [0...gameOfLife.maxGenerations()]
      if i is gameOfLife.currentGeneration()
        context.fillStyle = "#dddddd"
      else
        context.fillStyle = "#eeeeee"
      context.fillRect(i * xDelta, 0, xDelta - 2, height)

class GameOfLifeControl extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController
    @_gameOfLife = @_mainController._gameOfLife
    @_squareSide = 20
    @_padding = 1

  draw: (context) ->
    width = @rectangle.width
    height = @rectangle.height
    rows = @_mainController._rows
    cols = @_mainController._cols

    for row in [0...rows]
      for col in [0...cols]
        if @_gameOfLife.isCellAlive(col,row)
          context.fillStyle = "#555555"
        else if @_gameOfLife.isAliveInSeed(col,row)
          context.fillStyle = "#dddddd"
        else
          context.fillStyle = "#eeeeee"

        context.fillRect(@_squareSide * col + @_padding * (col - 1),
            @_squareSide * row + @_padding * (row - 1),
          @_squareSide,
          @_squareSide)

    #console.log(@_squareSide * cols + @_padding * (cols - 1))
    #console.log(@_squareSide * rows + @_padding * (rows - 1))

  getCellCoordinatesAt: (x, y) =>
    rows = @_mainController._rows
    cols = @_mainController._cols
    for row in [0...rows]
      for col in [0...cols]
        left = @_squareSide * col + @_padding * (col - 1)
        top  = @_squareSide * row + @_padding * (row - 1)
        if x > left and x < (left + @_squareSide) and y > top and y < (top + @_squareSide)
          return [col, row]
    [-1, -1]

  mouseDown: (x, y, view_x, view_y) ->
    cell_coords = this.getCellCoordinatesAt(x, y)
    @_gameOfLife.toggleAliveInSeed(cell_coords[0], cell_coords[1])
    window.application.draw() # TODO: fix this, it is super ugly

class GameOfLifePage extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController
    @_gameOfLifeControl = new GameOfLifeControl(new UI.Rectangle(0,0,800,600), mainController)
    @addSubView(@_gameOfLifeControl)

    # TODO: Magic number alert below, fix
    @_generationSliderControl = new GenerationSliderControl(new UI.Rectangle(70, 350, 500, 50), mainController)
    @addSubView(@_generationSliderControl)

    @_buttonLeft = new UI.ArrowButton(new UI.Rectangle(0, 350, 70, 50), UI.ArrowButton.LEFT)
    @addSubView(@_buttonLeft)

    @_buttonRight = new UI.ArrowButton(new UI.Rectangle(475, 350, 70, 50), UI.ArrowButton.RIGHT)
    @addSubView(@_buttonRight)

  draw: (context) ->
    undefined
    #context.fillStyle = "#cea260"
    #context.fillRect(0, 0, @rectangle.width, @rectangle.height)

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


