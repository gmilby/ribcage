# # Template view
#
# This module implements the template view. This view eases the typical
# workflow of rendering a template.
#
# This module is in UMD module and creates `Ribcage.views.templateView`,
# `Ribcage.views.TemplateView`, `Ribcage.viewMixins.TemplateView` if not used
# with an AMD module loader such as RequireJS.

if typeof define isnt 'function' or not define.amd
  @require = (dep) =>
    (() =>
      switch dep
        when 'ribcage/views/base' then @Ribcage.views.baseView
        else null
    )() or throw new Error "Unmet dependency #{dep}"
  @define = (factory) =>
    (@Ribcage or= {}).views or= {}
    @Ribcage.viewMixins or= {}
    @Ribcage.views.templateView = factory @require
    @Ribcage.views.TemplateView = @Ribcage.views.templateView.View
    @Ribcage.viewMixins.TemplateView = @Ribcage.views.templateView.mixin

define (require) ->
  Backbone = require 'backbone'
  _ = require 'underscore'

  # ## `templateViewMixin`
  #
  # This mixin implements the API for the `TemplateView`.
  templateViewMixin =
    # ### `templateViewMixin.templateSettings`
    #
    # This property is passed in as template settings. The default value is
    # `null`. If the template function you are using (default is Underscore
    # template) takes extra settings, you can use this property to specify it.
    templateSettings: null

    # ### `templateViewMixin.templateSource`
    #
    # The template source to render. It provides a simple default for debugging
    # purposes.
    templateSource: '<p>Please override me</p>'

    # ### `templateViewMixin.template`
    #
    # Template to render. This method takes data and passes it to Underscore's
    # `#template()` method. The default implementation renders the
    # `#templateSource` property.
    template: (data) ->
      _.template @templateSource, data, @templateSettings

    # ### `templateViewMixin.getContext()`
    #
    # Returns template context data. Should return an object whose keys will be
    # used in the template's scope.
    getTemplateContext: () ->
      {}

    # ### `templateViewMixin.beforeRender()`
    #
    # Called before render performs its magic. Does nothing by default.
    beforeRender: () ->
      this

    # ### `templateViewMixin.renderTemplate()`
    #
    # Render the template given a context.
    renderTemplate: (context) ->
      @template context

    # ### `templateViewMixin.insertTemplate()`
    #
    # Insert rendered template to DOM.
    insertTemplate: (html) ->
      @$el.html html

    # ### `templateViewMixin.afterRender()`
    #
    # Called after rendering is finished. Does nothing by default.
    afterRender: (context) ->
      this

    # ### `templateViewMixin.render()`
    #
    # Calls the pre- and post-rendering hooks, compiles the template, and
    # attaches it to the DOM tree.
    render: () ->
      @beforeRender()
      context = @getTemplateContext()
      @insertTemplate @renderTemplate context
      @afterRender context
      this # return this so the call can be chained

  # ## `TemplateView`
  #
  # Please see the documentation for the `templateViewMixin` for more
  # information on the API that this view provides.
  TemplateView = Backbone.View.extend templateViewMixin

  mixin: templateViewMixin
  View: TemplateView