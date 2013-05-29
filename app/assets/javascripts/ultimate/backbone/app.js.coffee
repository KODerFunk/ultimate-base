#= require ./base

class Ultimate.Backbone.App
  @App: null

  name: null

  Models: {}
  Collections: {}
  Routers: {}
  ViewMixins: {}
  ProtoViews: {}
  Views: {}
  viewInstances: []

  constructor: (name = null) ->
    if @constructor.App
      throw new Error('Can\'t create new Ultimate.Backbone.App because the single instance has already been created')
    else
      cout 'info', 'Ultimate.Backbone.App.constructor', name, @
      @constructor.App = @
      @name = name

  start: ->
    @bindViews()
    @bindCustomElements(true)

  bindViews: (jRoot = $('html')) ->
    bindedViews = []
    for viewName, viewClass of @Views when viewClass::el
      #cout 'info', "Try bind #{viewName} [#{viewClass::el}]"
      jRoot.find(viewClass::el).each (index, el) =>
        view = new viewClass(el: el)
        cout 'info', "Binded view #{viewName}:", view
        @viewInstances.push view
        bindedViews.push view
    bindedViews

  unbindViews: (views) ->
    view.undelegateEvents()  for view in views
    @viewInstances = _.without(@viewInstances, views...)

  getFirstView: (viewClass) ->
    for view in @viewInstances
      if view.constructor is viewClass
        return view
    null

  getAllViews: (viewClass) ->
    _.filter(@viewInstances, (view) -> view.constructor is viewClass)



  customElementBinders: []

  registerCustomElementBinder: (binder) ->
    @customElementBinders.push binder

  bindCustomElements: (jRoot = $('body'), initial = false) ->
    for binder in @customElementBinders
      binder arguments...



_.extend Ultimate.Backbone.App::, Backbone.Events
