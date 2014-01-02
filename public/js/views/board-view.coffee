define [
  'js/lib/lodash'
  'js/lib/backbone'
  'js/views/tile-view'
], (
  _
  Backbone
  TileView
) ->
  KEY_LEFT  = 37
  KEY_UP    = 38
  KEY_RIGHT = 39
  KEY_DOWN  = 40

  class BoardView extends Backbone.View
    constructor: (viewOpts, @tileSize = 32) ->
      super(viewOpts)

    initialize: ->
      # Adjust CSS widths
      @$('.board').css({
        width  : (@tileSize * @model.attributes.width) + 'px'
        height : (@tileSize * @model.attributes.height) + 'px'
      })
      @$el.css({
        width  : (@tileSize * @model.attributes.width) + 'px'
      })

      # Init tiles
      attrs = @model.attributes
      allTiles = _.reduce(
        [attrs.goals, attrs.boxes, attrs.walls, attrs.floors, [attrs.player]], 
        (result, next) -> result.concat(next))
      for tile in allTiles
        view = new TileView({
          id    : tile.id
          model : tile
        }, @tileSize)
        @$('.board').append(view.el)

      @_keypressHandler = _.bind(@_keypress, @)
      $(document).on('keydown', @_keypressHandler)

    close: ->
      # Clear tiles
      @$('.board').empty()

      # Detach event listeners
      $(document).off('keydown', @_keypressHandler)

    _keypress: (e) ->
      switch e.keyCode
        when KEY_LEFT then @model.movePlayer(-1, 0)
        when KEY_RIGHT then @model.movePlayer(1, 0)
        when KEY_UP then @model.movePlayer(0, -1)
        when KEY_DOWN then @model.movePlayer(0, 1)
        when 90
          # Ctrl-Z
          if e.ctrlKey then @model.undoLastMove()


