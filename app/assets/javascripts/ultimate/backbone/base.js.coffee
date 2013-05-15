#  require:
#    jquery ~> 1.7.0
#    underscore ~> 1.3.0

#= require ../base

Ultimate.Backbone ||=

  ViewMixins: {}

  isView: (view) -> view instanceof Backbone.View

  isViewClass: (viewClass) -> (viewClass::) instanceof Backbone.View

  isModel: (model) -> model instanceof Backbone.Model

  isCollection: (collection) -> collection instanceof Backbone.Collection

  isRouter: (router) -> router instanceof Backbone.Router

#  MixinSupport:
#    include: (mixin) ->
#      unless mixin?
#        throw new Error('Mixin is undefined')
#      _.extend @::, mixin
