UI = require('../ui/UI.coffee')
GameOfLifeControl = require('./GameOfLifeControl.coffee')
GenerationSliderControl = require('./GenerationSliderControl.coffee')

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

module.exports = GameOfLifePage
