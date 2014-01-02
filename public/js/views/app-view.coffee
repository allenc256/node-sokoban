define [
  'js/lib/lodash'
  'js/lib/backbone'
  'js/models/board-model'
  'js/views/board-view'
  'hbs!templates/app'
  'hbs!templates/levels'
], (
  _
  Backbone
  BoardModel
  BoardView
  appTemplate
  levelsTemplate
) ->
  FINISHED_QUOTES = [
    'good job!'
    'nice work!'
    'you rock!'
    'well done!'
    'awesome!'
  ]

  class AppView extends Backbone.View
    constructor: (@router, viewOpts) ->
      super(viewOpts)

    initialize: ->
      @render()

      @listenTo(@model, 'change:level', _.bind(@_changeLevel, @))
      @_initLevel() if @model.attributes.level?

    events: -> {
      'click .restart-level-btn' : '_restartLevel'
      'click .next-level-btn'    : '_nextLevel'
      'click .undo-move-btn'     : '_undoLastMove'
      'change .pack-select'      : '_packChanged'
      'change .level-select'     : '_levelChanged'
    }

    render: ->
      @$el.html(appTemplate(@model.attributes))

    _initLevel: ->
      @boardModel = new BoardModel(@model.attributes.level.lines)
      @boardView  = new BoardView({ el: @$('.board-view'), model: @boardModel })

      @listenTo @boardModel, 'change:completed', =>
        @_updateGoalStatus()
        @_showFinishedDialog() if @boardModel.isFinished()

      @_updateInstructions()
      @_updateGoalStatus()
      @_updateLevelStatus()

    _closeLevel: ->
      return if not @boardModel?

      @boardView.close()
      @stopListening(@boardModel)

      delete @boardModel
      delete @boardView

    _restartLevel: ->
      @boardModel?.reset()

    _changeLevel: ->
      @_closeLevel()
      @_initLevel()

    _nextLevel: ->
      @_hideFinishedDialog()

      a         = @model.attributes
      nextLevel = a.levelNum + 1

      if nextLevel < _.size(a.levelPack.levels)
        # Update max openable level
        m = Math.max(nextLevel, @model.getMaxOpenableLevel(a.levelPack.name))
        @model.setMaxOpenableLevel(a.levelPack.name, m)
        @router.navigateToLevel(a.levelPack.name, nextLevel)
      else
        # Move on to next pack
        nextPack = a.levelPacks[(a.levelPackNum + 1) % a.levelPacks.length].name
        @router.navigateToLevel(nextPack, 0)

    _showFinishedDialog: ->
      @$('.finished-dialog-outer').css('z-index', 200)
      @$('.finished-dialog-text').html(_.sample(FINISHED_QUOTES))

      # Show remarks if finishing set.
      a = @model.attributes
      if a.levelNum == _.size(a.levelPack.levels)-1
        @$('.finished-dialog-remarks').html("You've finished level set <b>#{a.levelPack.name}</b>!").show()
      else
        @$('.finished-dialog-remarks').hide()

      @$('.finished-dialog').fadeIn(300)

    _hideFinishedDialog: ->
      @$('.finished-dialog-outer').css('z-index', 0)
      @$('.finished-dialog').fadeOut(300)

    _updateInstructions: ->
      el = @$('.instructions')
      i  = @model.attributes.level.instructions
      if i? then el.html(i).show() else el.hide()

    _updateLevelStatus: ->
      a = @model.attributes

      # Document title
      document.title = "Sokoban - #{a.level.name}"

      packs  = _.map(a.levelPacks, (p) -> { name: p.name, selected: p.name == a.levelPack.name })
      levels = a.levelPack.levels[0..@model.getMaxOpenableLevel(a.levelPack.name)]
      levels = _.map(levels, (name) -> { name: name, selected: name == a.level.name })

      @$('.level-status').html(levelsTemplate({
        packs  : packs, 
        levels : levels, 
        author : a.levelPack.author
      }))

      # Resize "select" elements according to selected options
      # http://stackoverflow.com/questions/20091481
      @$('.pack-select').width($("#width_tmp").html(a.levelPack.name).width() + 30)
      @$('.level-select').width($("#width_tmp").html(a.level.name).width() + 30)

    _updateGoalStatus: ->
      a = @boardModel.attributes
      @$('.goals-status').html("<b>Targets:</b> #{a.completed}/#{_.size(a.goals)}")

    _packChanged: ->
      pack = @$('.pack-select :selected').text()
      @router.navigateToLevel(pack, @model.getMaxOpenableLevel(pack))

    _levelChanged: ->
      num = @$('.level-select')[0].selectedIndex
      @router.navigateToLevel(@model.attributes.levelPack.name, num)

    _undoLastMove: ->
      @boardModel.undoLastMove()
