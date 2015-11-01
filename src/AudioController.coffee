
class BufferLoader
  constructor: (@_audioContext, @_urlList, @_callback) ->
    @_bufferList = []
    @_loadCount = 0

  _loadBuffer: (url, idx) ->
    request = new XMLHttpRequest()
    request.open('GET', url, true)
    request.responseType = "arraybuffer"

    request.onload = =>
      @_audioContext.decodeAudioData request.response, (buffer) =>
        if not buffer
          alert("Error decoding data for : #{url}")
          return
        @_bufferList[idx] = buffer
        @_loadCount = @_loadCount + 1
        if @_loadCount == @_urlList.length
          @_callback(@_bufferList)
      , (error) ->
        console.error "decodeAudioData error #{error}"

    request.onerror = ->
      alert "BufferLoader: XHR Error"

    request.send()

  load: ->
    for idx in [0...@_urlList.length]
      @_loadBuffer @_urlList[idx], idx

class AudioController
  constructor: ->
    @_ac = new AudioContext()
    bl = new BufferLoader(@_ac, [
      "samples/Movements-15.wav",
      "samples/Tech-11.wav",
      "samples/Tech-17.wav",
      "samples/Tech-21.wav",
      "samples/Vox-16.wav",
      "samples/Vox-17.wav"
    ], @_doneLoading)
    bl.load()
    @_buffers = []


  _doneLoading: (bufferList) =>
    for buffer in bufferList
      @_buffers.push buffer

  triggerSequencerAt: (idx) ->
    return
    if idx of @_buffers
      source = @_ac.createBufferSource()
      source.buffer = @_buffers[idx]
      source.connect @_ac.destination
      source.start 0

module.exports = AudioController
