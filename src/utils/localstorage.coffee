###!
@author Branko Vukelic <branko@brankovukelic.com>
@license MIT
###

# # Local storage interface
#
# This is a simple `localStorage` API interface that falls back on memory
# storage.
#
# This module is in UMD format and will return a `ribcage.utils.LocalStorage`
# global if not used with an AMD loader such as RequireJS.

if typeof define isnt 'function' or not define.amd
  @define = (factory) =>
    (@ribcage or= {}).utils or= {}
    @ribcage.utils.LocalStorage = factory()

define () ->

  # ## `LocalStorage`
  #
  # This constructor implements the `localStorage` API that wraps around native
  # `localStorage` object with fallback on in-memory storage.
  #
  # The constructor takes a single boolean `debug` argument that tells the
  # object whether to log its actions. It currently has no effect.
  #
  # All data is internally stored as JSON and deserialized on retrieval.
  class LocalStorage
    constructor: (@debug=false) ->
      @hasNative = 'localStorage' of window
      if @hasNative
        @localStorage = window.localStorage
      else
        @localStorage = (() ->
          # Creates faux localStorage interface that uses a simple object to
          # store all of its values.

          store = {}

          getItem: (key) ->
            store[key]
          setItem: (key, value) ->
            store[key] = value
          removeItem: (key) ->
            del store[key] if store[key]?
        )()

    # ### `LocalStorage.prototype.getItem(key, [raw])
    #
    # Gets data with given key.
    #
    # The `raw` argument is a boolean and data is returned raw without
    # deserialization if it's set to `true`.
    getItem: (key, raw=false) ->
      val = @localStorage.getItem(key)

      return val if raw

      try
        JSON.parse(val)
      catch e
        return null

    # ### `LocalStorage.prototype.setItem(key, value, [raw])`
    #
    # Sets `val` as data for given key.
    #
    # The `raw` argument is a boolean and data is set raw without serialization
    # if it's set to `true`.
    setItem: (key, val, raw=false) ->
      val = if raw then val else JSON.stringify(val)
      @localStorage.setItem key, val

    # ### `LocalStorage.prototype.removeItem(key)`
    #
    # Removes data with given key from local storage.
    removeItem: (key) ->
      @localStorage.removeItem key
      true
