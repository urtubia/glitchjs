View = require('./View.coffee')

# TODO this is not really used anymore... kill it?
class ArrowButton extends View
  @LEFT: 0
  @RIGHT: 1

  constructor: (rectangle, direction) ->
    super(rectangle)
    #@_direction = direction

  draw: (context) ->
    context.fillStyle = "#cccccc"
    context.fillRect(0, 0, @_rectangle.width, @_rectangle.height)

module.exports = ArrowButton
