# Cached regex to split keys for `delegate`, from backbone.js.
delegateEventSplitter = /^(\S+)\s*(.*)$/

Ultimate.Backbone.ViewMixins.Nodes =

  nodes: null

  # Overwritten parent method Backbone.View.setElement() as hook for findNodes()
  setElement: (element, delegate) ->
    @undelegateEvents()  if @$el
    @$el = if element instanceof Backbone.$ then element else Backbone.$(element)
    @el = @$el[0]
    @findNodes() # inserted hook
    @delegateEvents()  if delegate isnt false
    @

  findNodes: (jRoot = @$el, nodes = @nodes) ->
    jNodes = {}
    nodes = @nodes.call(@)  if _.isFunction(nodes)
    if _.isObject(nodes)
      for nodeName, selector of nodes  when nodeName isnt 'selector'
        _isObject = _.isObject(selector)
        if _isObject
          nestedNodes = selector
          selector = nestedNodes['selector']
        jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
        if _isObject
          _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes

  # Overload and proxy parent method Backbone.View.delegateEvents() as hook for normalizeEvents().
  delegateEvents: (events) ->
    args = _.toArray(arguments)
    args[0] = @normalizeEvents(events)
    @__super 'delegateEvents', args

  # TODO docs
  normalizeEvents: (events) ->
    events = _.result(@, "events")  unless events
    if events
      normalizedEvents = {}
      for key, method of events
        [[], eventName, selector] = key.match(delegateEventSplitter)
        selector = _.result(@, selector)
        selector = selector.selector  if selector instanceof Backbone.$
        if _.isString(selector)
          selector = selector.replace(@$el.selector, '')  if _.string.startsWith(selector, @$el.selector)
          key = "#{eventName} #{selector}"
        normalizedEvents[key] = method
      events = normalizedEvents
    events
