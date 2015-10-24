View = require('./View.coffee')
Rectangle = require('./Rectangle.coffee')

class Application
  constructor: (canvas_div, @_width, @_height) ->
    @_canvas_div = canvas_div
    @_canvas_div.onmousedown = this.onMouseDown
    @_canvas_div.onmousemove = this.onMouseMove
    @_canvas_div.onmouseup = this.onMouseUp

    @_rootView = new View(new Rectangle(0,0,@_width, @_height))
    @_initCanvasContext()

  getRootView: ->
    @_rootView

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

  _initCanvasContext: ->
    @_canvas = document.createElement('canvas')
    @_canvas.setAttribute('width', @_width)
    @_canvas.setAttribute('height', @_height)
    @_canvas.setAttribute('id', 'canvas')
    @_canvas_div.appendChild(@_canvas)
    @_ctx = @_canvas.getContext("2d")

module.exports = Application
