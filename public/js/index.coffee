# Load require config before anything else.
require ['require-conf'], ->
  # Now run the actual app.
  require [
    'js/lib/jquery'
    'js/lib/lodash'
    'js/models/app-model'
    'js/views/app-view'
    'js/router'
  ], (
    $
    _
    AppModel
    AppView
    AppRouter
  ) ->
    $ ->
      model  = new AppModel()
      model.loadLevelPacks().done ->
        router = new AppRouter(model)
        view   = new AppView(router, { el: '.app', model: model })

        # Init router
        Backbone.history.start()

        # Navigate to level (if no route specified)
        hash = window.location.hash
        if not hash? or hash.length == 0
          {lastLevelPackName, lastLevelNum} = model.getLastLevel()
          lastLevelPackName ||= model.attributes.levelPacks[0].name
          lastLevelNum      ||= 0
          router.navigateToLevel(lastLevelPackName, lastLevelNum, { trigger: true, replace: true })
