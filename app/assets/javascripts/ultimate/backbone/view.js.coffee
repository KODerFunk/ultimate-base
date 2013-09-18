#= require ./base

class Ultimate.Backbone.View extends Backbone.View

  @mixinNames: null

  # Rest mixinNames
  @mixinable: ->
    @mixinNames = _.clone(@mixinNames)

  # Mixins support
  @include: (mixin, name = null) ->
    @mixinNames ||= []
    @mixinNames.push(name)  if name?
    unless mixin?
      throw new Error("Mixin #{name} is undefined")
    _.extend @::, mixin

  mixinsEvents: (events = {}) ->
    _.reduce( @constructor.mixinNames,  ( (memo, name) -> _.extend(memo, _.result(@, _.string.camelize(name + 'Events'))) ), events, @ )

  mixinsInitialize: ->
    for name in @constructor.mixinNames
      @[_.string.camelize(name + 'Initialize')]? arguments...
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

  # Overload parent method Backbone.View._configure() as hook for reflectOptions()
  _configure: (options) ->
    super
    @reflectOptions()

  reflectOptions: (options = @options) ->
    @[attr] = value  for attr, value of options  when not _.isUndefined(@[attr])
    @
