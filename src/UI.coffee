
class Rectangle
  constructor: (@x, @y, @width, @height) ->

class View
  constructor: (@rectangle) ->
    @_hidden = false
    @_subViews = []
    @_backgroundColor = "#000000"

  addSubView: (subView) ->
    @_subViews.push(subView)

  update: (context) ->
    context.save()
    context.translate(@rectangle.x, @rectangle.y)
    this.draw(context)
    context.restore()
    for subview in @_subViews
      if not subview._hidden then subview.update(context)

  mouseDown: (x, y,view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseDown(x - subview.rectangle.x, y - subview.rectangle.y, view_x, view_y)

  mouseMove: (x, y,view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseMove(x - subview.rectangle.x, y - subview.rectangle.y, view_x, view_y)

  mouseUp: (x, y, view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseUp(x - subview.rectangle.x, y - subview.rectangle.y, view_x, view_y)

  draw: (context) ->
    #context.fillStyle = @_backgroundColor
    #context.fillRect(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height)

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

module.exports =
  Rectangle: Rectangle
  View: View
  ArrowButton: ArrowButton
