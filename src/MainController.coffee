GameOfLife = require('./gameoflife.coffee')
AudioController = require('./AudioController.coffee')

class MainController
  constructor: ->
    @_cols = 26
    @_rows = 16
    @_gameOfLife = new GameOfLife(@_cols, @_rows)
    @_audioController = new AudioController()
    # TODO this is a hack to allow the app to read the sequencer data 
    setTimeout =>
      for seqIdx in [0...6]
        seq = @_gameOfLife.sequencerAt seqIdx
        do (seqIdx, seq) =>
          seq.setTriggerCallback () =>
            @_audioController.triggerSequencerAt seqIdx
    , 3000

    @_selectedPart = 0

  setSelectedPart: (selectedPart) ->
    @_selectedPart = selectedPart

  getSelectedPart: ->
    @_selectedPart

  toggleCell: (col, row) ->
    if @_selectedPart == 0
      @_gameOfLife.toggleAliveInSeed col, row
    else
      sequencer = @_gameOfLife.sequencerAt(@_selectedPart - 1)
      sequencer.toggleAlive col, row

module.exports = MainController

