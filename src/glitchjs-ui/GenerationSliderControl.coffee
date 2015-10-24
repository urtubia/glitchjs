UI = require('../ui/UI.coffee')

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

module.exports = GenerationSliderControl
