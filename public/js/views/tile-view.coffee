define [
  'lib/backbone'
], (
  Backbone
) ->
  IMAGES = {
    player : 'img/player.gif'
    wall   : 'img/wall.gif'
    box    : 'img/box.png'
    goal   : 'img/goal.gif'
    floor  : 'img/floor.png'
  }

  Z_INDEX = {
    floor  : 0
    goal   : 1
    box    : 2
    wall   : 3
    player : 4
  }

  class TileView extends Backbone.View
    constructor: (viewOpts, @tileSize) ->
      super(viewOpts)

    initialize: ->
      attrs = @model.attributes

      @$el.css({
        width              : @tileSize + 'px'
        height             : @tileSize + 'px'
        position           : 'absolute'
        'z-index'          : Z_INDEX[attrs.type]
        'background-image' : "url(#{IMAGES[attrs.type]})"
      })

      @_reposition()

      @model.on('change:x change:y', _.bind(@_reposition, @))

    _reposition: ->
      @$el.css({
        left : (@tileSize * @model.attributes.x) + 'px'
        top  : (@tileSize * @model.attributes.y) + 'px'
      })

