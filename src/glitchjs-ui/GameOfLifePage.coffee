UI = require('../ui/UI.coffee')
GameOfLifeControl = require('./GameOfLifeControl.coffee')
GenerationSliderControl = require('./GenerationSliderControl.coffee')
TopSelectionBar = require('./TopSelectionBar.coffee')
SequencerSelectionSideBar = require('./SequencerSelectionSideBar.coffee')

class GameOfLifePage extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController
    @_gameOfLifeControl = new GameOfLifeControl(new UI.Rectangle(0,50,800,600), mainController)
    @addSubView(@_gameOfLifeControl)

    # TODO: Magic number alert below, fix
    @_generationSliderControl = new GenerationSliderControl(new UI.Rectangle(70, 400, 500, 50), mainController)
    @addSubView(@_generationSliderControl)

    @_topSelectionBar = new TopSelectionBar(new UI.Rectangle(0,0,545, 45), mainController)
    @addSubView(@_topSelectionBar)

    @_sequencerSelectionSideBar = new SequencerSelectionSideBar(new UI.Rectangle(555, 50, 50, 336), mainController)
    @addSubView(@_sequencerSelectionSideBar)

    @_buttonLeft = new UI.ArrowButton(new UI.Rectangle(0, 400, 70, 50), UI.ArrowButton.LEFT)
    @addSubView(@_buttonLeft)

    @_buttonRight = new UI.ArrowButton(new UI.Rectangle(475, 400, 70, 50), UI.ArrowButton.RIGHT)
    @addSubView(@_buttonRight)

  draw: (context) ->
    #context.fillStyle = "#fafafa"
    #context.fillRect(0, 0, @_rectangle.width, @_rectangle.height)

module.exports = GameOfLifePage
