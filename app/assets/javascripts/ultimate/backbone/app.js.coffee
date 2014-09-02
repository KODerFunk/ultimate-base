#= require ./base

class Ultimate.Backbone.App
  @App: null

  name: null
  warnOnMultibind: true
  preventMultibind: false
  performanceReport: true

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
    @performanceReport = DEBUG_MODE if @performanceReport
    if @performanceReport
      if _.isFunction(performance?.now)
        performanceStart = performance.now()
      else
        cout 'warn', 'performance.now() isnt available'
        @performanceReport = null
    bindedViewsCount = @bindViews().length
    if @performanceReport
      performanceViews = performance.now()
      cout 'info', "Binded #{bindedViewsCount} view#{if bindedViewsCount is 1 then '' else 's'} in #{Math.round((performanceViews - performanceStart) * 1000)}\u00B5s"
    @bindCustomElements(null, true)
    if @performanceReport
      performanceBinders = performance.now()
      bindersCount = @customElementBinders.length
      cout 'info', "Processed #{bindersCount} custom element binder#{if bindersCount is 1 then '' else 's'} in #{Math.round((performanceBinders - performanceViews) * 1000)}\u00B5s"

  bindViews: (jRoot = $('html')) ->
    console?.groupCollapsed? 'bindViews on', jRoot
    bindedViews = []
    sortedViews = _.sortBy(_.pairs(@Views), (p) -> p[1].priority)
    for [viewName, viewClass] in sortedViews when viewClass::el
      #cout 'info', "Try bind #{viewName} [#{viewClass::el}]"
      jRoot.find(viewClass::el).each (index, el) =>
        if @canBind(el, viewClass)
          view = new viewClass(el: el)
          cout 'info', "Binded view #{viewName}:", view
          @viewInstances.push view
          bindedViews.push view
    console?.groupEnd?()
    bindedViews

  canBind: (element, viewClass) ->
    if @warnOnMultibind or @preventMultibind
      views = @getViewsOnElement(element)
      l = views.length
      if l > 0
        if @warnOnMultibind
          cout 'warn', "Element already has binded #{l} view#{if l > 1 then 's' else ''}", element, viewClass, views
        not @preventMultibind
      else
        true
    else
      true

  getViewsOnElement: (element) ->
    element = if element instanceof jQuery then element[0] else element
    _.where @viewInstances, el: element

  unbindViews: (views) ->
    for view in views
      view.undelegateEvents()
      view.leave?()
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
