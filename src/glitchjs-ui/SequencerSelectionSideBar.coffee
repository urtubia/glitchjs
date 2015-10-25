UI = require('../ui/UI.coffee')

class SequencerSelectionSideBar extends UI.View
  constructor: (rectangle, mainController) ->
    super(rectangle)
    @_mainController = mainController
    @_selectedPart = 0
    @_colors = ['#444444','#4AC127','#923796','#E5001F','#3235AA','#BB9600','#FA750F']

  draw: (context) ->
    # clear first
    context.fillStyle = "#ffffff"
    context.fillRect(0, 0, @_rectangle.width, @_rectangle.height)

    numParts = 7
    individualMaxHeight = @_rectangle.height / 7
    for i in [0...numParts]
      context.fillStyle = @_colors[i]
      if @_selectedPart == i then side = 40 else side = 20
      centerPoint =
        x: (@_rectangle.width / 2)
        y: (i * individualMaxHeight) + (individualMaxHeight / 2)
      halfSide = side /2
      context.fillRect(centerPoint.x - halfSide, centerPoint.y - halfSide, side, side)

  mouseDown: (x, y, view_x, view_y) ->
    if x < 0 or x > @_rectangle.width
      return
    selection = -1
    numParts = 7
    individualMaxHeight = @_rectangle.height / numParts
    for i in [0...numParts]
      minY = i * individualMaxHeight
      maxY = (i + 1) * individualMaxHeight
      if y > minY and y < maxY
        selection = i
    if selection != -1
      @_selectedPart = selection
      @triggerUpdate()

module.exports = SequencerSelectionSideBar
    
