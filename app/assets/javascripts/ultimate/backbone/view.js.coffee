#= require ./base

class Ultimate.Backbone.View extends Backbone.View

# Mixins support
  @include: (mixin) ->
    unless mixin?
      throw new Error('Mixin is undefined')
    _.extend @::, mixin

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
