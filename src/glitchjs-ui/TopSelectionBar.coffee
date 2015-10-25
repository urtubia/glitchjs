UI = require('../ui/UI.coffee')

class TopSelectionBar extends UI.View
  constructor: (rectangle, mainController) ->
    super(rectangle)
    @_mainController = mainController

  draw: (context) ->
    #context.fillStyle = "#a2fff0"
    #context.fillRect(0, 0, @_rectangle.width, @_rectangle.height)

module.exports = TopSelectionBar

    
