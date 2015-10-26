Firebase = require("firebase")

NUM_SEQUENCERS = 6

class Sequencer
  constructor: (@_cols, @_rows, @_seqFbRef) ->
    @_sequencerState = []
    
  init: ->
    for row in [0...@_rows]
      cols_array = []
      for col in [0...@_cols]
        cols_array.push(false)
      @_sequencerState.push(cols_array)
    @_seqFbRef.set(@_sequencerState)

  read: (val) ->
    for row in [0...@_rows]
      @_sequencerState.push(val[row])

  toggleAlive: (col, row) ->
    @setAliveIn col, row, !@_sequencerState[col][row]

  setAliveIn: (col, row, alive, persistValue = true) ->
    @_sequencerState[col][row] = alive
    if persistValue
      fbVal = @_seqFbRef.child("/#{col}/#{row}")
      fbVal.set alive

  isCellActive: (col, row) ->
    @_sequencerState[col][row]

class GameOfLife

  constructor: (cols, rows) ->
    @_currentGeneration = 0
    @_maxGenerations = 30
    @_rows = rows
    @_cols = cols
    @_sequencers = []

    @_fbRef = new Firebase('ADD_YOUR_OWN')
    @_seedFbRef = @_fbRef.child('seed')
    @_sequencersFbRef = @_fbRef.child('sequencers')
    @_initSeed()
    @_initSequencers()
  
  _initSequencers: ->
    @_sequencersFbRef.once 'value', (snapshot) =>
      val = snapshot.val()
      for seqIdx in [0...NUM_SEQUENCERS]
        seqFbRef = @_sequencersFbRef.child(seqIdx)
        sequencer = new Sequencer @_cols, @_rows, seqFbRef
        if val is null
          sequencer.init()
        else
          sequencer.read(val[seqIdx])
        @_sequencers.push(sequencer)

  _initSeed: ->
    @_seedFbRef.once 'value', (snapshot) =>
      val = snapshot.val()
      if val is null
        @_seedPopulation = [] # array of rows
        for row in [0...@_rows]
          cols_array = []
          for col in [0...@_cols]
            cols_array.push(false)
          @_seedPopulation.push(cols_array)
        @_seedFbRef.set(@_seedPopulation)
      else
        @_seedPopulation = [] # array of rows
        for row in [0...@_rows]
          @_seedPopulation.push(val[row])
        @_seedFbRef.set(@_seedPopulation)

      @_currentPopulation = []
      for row in [0...@_rows]
        cols_array = []
        for col in [0...@_cols]
          cols_array.push(false)
        @_currentPopulation.push(cols_array)

      @resetPopulation()

      @_seedFbRef.on 'value', (snapshot) =>
        val = snapshot.val()
        @_seedPopulation = [] # array of rows
        for row in [0...@_rows]
          @_seedPopulation.push(val[row])

  resetPopulation: ->
    for row in [0...@_rows]
      for col in [0...@_cols]
        @_currentPopulation[row][col] = @_seedPopulation[row][col]
    @_currentGeneration = 0

  _liveNeighbors: (col, row) ->
    liveNeighbors = 0
    for rowDelta in [-1..1]
      for colDelta in [-1..1]
        if not (rowDelta == 0 and colDelta == 0)
          targetRow = (row + rowDelta) % @_rows
          if targetRow < 0
            targetRow = @_rows + targetRow
          targetCol = (col + colDelta) % @_cols
          if targetCol < 0
            targetCol = @_cols + targetCol
          if @_currentPopulation[targetRow][targetCol]
            liveNeighbors = liveNeighbors + 1
    liveNeighbors

  isCellAlive: (col, row) ->
    @_currentPopulation[col][row]

  isAliveInSeed: (col, row) ->
    @_seedPopulation[col][row]

  setAliveInSeed: (col, row, alive, persistValue = true) ->
    @_seedPopulation[col][row] = alive
    if persistValue
      fbVal = @_seedFbRef.child("/#{col}/#{row}")
      fbVal.set alive

  toggleAliveInSeed: (col, row) ->
    @setAliveInSeed col, row, !@_seedPopulation[col][row]

  advanceGeneration: =>
    if @_currentGeneration >= @_maxGenerations
      this.resetPopulation()
      return

    newGeneration = []
    for row in [0...@_rows]
      newGeneration.push([])
      for col in [0...@_cols]
        live_cell = @_currentPopulation[row][col]
        live_neighbors = this._liveNeighbors(col,row)
        if not live_cell and live_neighbors == 3
          newGeneration[row].push(true)
        else if (live_cell and live_neighbors == 2) or (live_cell and live_neighbors == 3)
          newGeneration[row].push(true)
        else
          newGeneration[row].push(false)

    for row in [0...@_rows]
      for col in [0...@_cols]
        @_currentPopulation[row][col] = newGeneration[row][col]

    @_currentGeneration++

  maxGenerations: ->
    @_maxGenerations

  setMaxGenerations: (maxGenerations) ->
    @_maxGenerations = maxGenerations

  currentGeneration: ->
    @_currentGeneration

  sequencerAt: (seqIdx) ->
    @_sequencers[seqIdx]


module.exports = GameOfLife
