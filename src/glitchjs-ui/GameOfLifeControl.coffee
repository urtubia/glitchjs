UI = require('../ui/UI.coffee')

class GameOfLifeControl extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController
    @_gameOfLife = @_mainController._gameOfLife
    @_squareSide = 20
    @_padding = 1

    # TODO: Fix this non-DRY declaration
    @_colors = ['#444444','#4AC127','#923796','#E5001F','#3235AA','#BB9600','#FA750F']

  draw: (context) ->
    width = @_rectangle.width
    height = @_rectangle.height
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

        for seqIdx in [0...6]
          sequencer = @_mainController._gameOfLife.sequencerAt seqIdx
          if sequencer.isCellActive(col,row)
            context.fillStyle = @_colors[seqIdx]

        context.fillRect(@_squareSide * col + @_padding * (col - 1),
            @_squareSide * row + @_padding * (row - 1),
          @_squareSide,
          @_squareSide)

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
    cell_coords = @getCellCoordinatesAt(x, y)
    if cell_coords[0] != -1 and cell_coords[1] != -1
      @_mainController.toggleCell(cell_coords[0], cell_coords[1])
      @triggerUpdate()

module.exports = GameOfLifeControl
