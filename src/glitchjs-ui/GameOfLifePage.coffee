UI = require('../ui/UI.coffee')
GameOfLifeControl = require('./GameOfLifeControl.coffee')
GenerationSliderControl = require('./GenerationSliderControl.coffee')
SequencerSelectionSideBar = require('./SequencerSelectionSideBar.coffee')

class GameOfLifePage extends UI.View
  constructor: (rectangle, mainController) ->
    super rectangle
    @_mainController = mainController
    @_gameOfLifeControl = new GameOfLifeControl(new UI.Rectangle(0,0,800,600), mainController)
    @addSubView(@_gameOfLifeControl)

    # TODO: Magic number alert below, fix
    @_generationSliderControl = new GenerationSliderControl(new UI.Rectangle(70, 350, 500, 50), mainController)
    @addSubView(@_generationSliderControl)

    @_sequencerSelectionSideBar = new SequencerSelectionSideBar(new UI.Rectangle(555, 0, 50, 336), mainController)
    @addSubView(@_sequencerSelectionSideBar)
    @_sequencerSelectionSideBar.onSelectionChanged (newSelectedPart) =>
      @_mainController.setSelectedPart newSelectedPart

    @_buttonLeft = new UI.ArrowButton(new UI.Rectangle(0, 350, 70, 50), UI.ArrowButton.LEFT)
    @addSubView(@_buttonLeft)

    @_buttonRight = new UI.ArrowButton(new UI.Rectangle(475, 350, 70, 50), UI.ArrowButton.RIGHT)
    @addSubView(@_buttonRight)

  draw: (context) ->
    #context.fillStyle = "#fafafa"
    #context.fillRect(0, 0, @_rectangle.width, @_rectangle.height)

module.exports = GameOfLifePage
