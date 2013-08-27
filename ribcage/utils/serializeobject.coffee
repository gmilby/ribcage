# # Serialize form to object
#
# This module provides a helper method to serialize form into an object. The
# helper method is also attached to jQuery as both a `$.serializeForm` method
# as well as `$.fn.serializeForm` method.
#
# The model is in UMD format, and will create a `Ribcage.utils.serializeForm`
# global if not used with an AMD loader such as RequireJS.

if typeof define isnt 'function' or not define.amd
  @require = (dep) =>
    (() =>
      switch dep
        when 'jquery' then @jQuery
        when 'underscore' then @_
        else null
    )() or throw new Error "Unmet dependency #{dep}"
  @define = (factory) =>
    (@Ribcage or= {}).utils or= {}
    @Ribcage.utils.serializeForm = factory @require

define (require) ->
  $ = require 'jquery'
  _ = require 'underscore'

  # ## `$.serializeObject(form)`
  #
  # Returns an object containing form data for a form represented by `form`
  # selector or jQuery object.
  #
  # If there are multiple values with the same name (such as multi-select
  # input), they are converted to arrays.
  $.serializeObject = (form) ->
    form = $ form
    arr = form.serializeArray()
    data = {}
    for {name, value} in arr
      if name of data
        # Convert to array if needed
        data[name] = if _.isArray data[name] then data[name] else [data[name]]
        data[name].push value
      else
        data[name] = value
    data

  # ## `.serializeObject()`
  #
  # Serializes the selected form into an object. This is a wrapper around
  # `$.serializeForm()`.
  $.fn.serializeObject = () ->
    $.serializeObject this

  $.serializeObject