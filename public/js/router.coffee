define [
  'lib/backbone'
], (
  Backbone
) ->
  class AppRouter extends Backbone.Router
    constructor: (@model, routerOpts) ->
      super(routerOpts)

    routes: -> {
      'levels/:pack/:level' : (pack, level) =>
        @model.loadLevel(pack, parseInt(level)).done ->
    }

    navigateToLevel: (pack, level, options = { trigger:true }) ->
      @navigate("levels/#{encodeURIComponent(pack)}/#{level}", options)
