Rectangle = require('./Rectangle.coffee')

class View
  constructor: (@_rectangle) ->
    @_hidden = false
    @_subViews = []
    @_backgroundColor = "#000000"
    @_application = null
    @_parentView = null

  addSubView: (subView) ->
    subView._application = @_application
    subView._parentView = @
    @_subViews.push(subView)

  getBounds: ->
    @_rectangle

  triggerUpdate: ->
    viewWithApplication = @
    while viewWithApplication._application == null
      viewWithApplication = viewWithApplication._parentView
    viewWithApplication._application.draw()

  update: (context) ->
    context.save()
    context.translate(@_rectangle.x, @_rectangle.y)
    this.draw(context)
    context.restore()
    for subview in @_subViews
      if not subview._hidden then subview.update(context)

  mouseDown: (x, y,view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseDown(x - subview._rectangle.x, y - subview._rectangle.y, view_x, view_y)

  mouseMove: (x, y,view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseMove(x - subview._rectangle.x, y - subview._rectangle.y, view_x, view_y)

  mouseUp: (x, y, view_x, view_y) ->
    # TODO do some sort of hit testing to stop propagating event
    for subview in @_subViews
      if not subview._hidden
        subview.mouseUp(x - subview._rectangle.x, y - subview._rectangle.y, view_x, view_y)

  draw: (context) ->
    #context.fillStyle = @_backgroundColor
    #context.fillRect(@rectangle.x, @rectangle.y, @rectangle.width, @rectangle.height)

module.exports = View
