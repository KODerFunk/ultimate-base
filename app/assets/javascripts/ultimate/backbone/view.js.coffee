#= require ./base

class Ultimate.Backbone.View extends Backbone.View

  @mixinNames: null

  constructor: (options) ->
    @reflectOptions options
    super

  # Rest mixinNames
  @mixinable: ->
    @mixinNames = if @mixinNames then _.clone(@mixinNames) else []

  # Mixins support
  @include: (mixin, name = null) ->
    @mixinNames ||= []
    @mixinNames.push(name)  if name?
    unless mixin?
      throw new Error("Mixin #{name} is undefined")
    _.extend @::, mixin

  mixinsEvents: (events = {}) ->
    _.reduce( @constructor.mixinNames,  ( (memo, name) -> _.extend(memo, _.result(@, name + 'Events')) ), events, @ )

  mixinsInitialize: ->
    for name in @constructor.mixinNames
      @[name + 'Initialize']? arguments...
    @

  # TODO comment for this trick
  __super: (methodName, args) ->
    obj = @
    calledMethod = @[methodName]
    obj = obj.constructor.__super__  while obj[methodName] is calledMethod
    superMethod = obj[methodName]
    unless superMethod?
      throw new Error("__super can't find super method '#{methodName}'")
    superMethod.apply @, args

  reflectOptions: (options) ->
    @[attr] = value  for attr, value of options  when not _.isUndefined(@[attr])
    @
