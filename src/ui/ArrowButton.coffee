View = require('./View.coffee')

class ArrowButton extends View
  @LEFT: 0
  @RIGHT: 1

  constructor: (rectangle, direction) ->
    super(rectangle)
    #@_direction = direction

  draw: (context) ->
    context.fillStyle = "#ee0066"
    context.fillRect(0, 0, @rectangle.width, @rectangle.height)
    console.log "done button draw"

module.exports = ArrowButton
