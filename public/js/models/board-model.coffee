define [
  'js/lib/lodash'
  'js/lib/backbone'
], (
  _
  Backbone
) ->
  class BoardModel extends Backbone.Model
    constructor: (@lines, attrs) ->
      super(attrs)

      lines  = _.filter(lines, (s) -> s.trim().length > 0)
      width  = _.max(_.pluck(lines, 'length'))
      height = lines.length

      @set({
        width   : width
        height  : height
        player  : @_createObjects(lines, width, height, 'player', ['@', '+'])[0]
        walls   : @_createObjects(lines, width, height, 'wall', ['#'])
        boxes   : @_createObjects(lines, width, height, 'box', ['$', '*'])
        goals   : @_createObjects(lines, width, height, 'goal', ['*', '+', '.'])
        floors  : []
        history : []
      })

      @_createFloors(lines, @attributes.player.attributes.x, @attributes.player.attributes.y, {}, @attributes.floors)

      # Compute goals completed (depends on attributes above)
      @_computeCompleted()

    _createObjects: (lines, width, height, type, chars) ->
      result = []
      for y in [0...height]
        for x in [0...width]
          if _.contains(chars, lines[y][x])
            result.push(new Backbone.Model({
              id    : "#{type}-#{x}-#{y}"
              type  : type
              x     : x
              y     : y
              origX : x
              origY : y
            }))
      return result

    _createFloors: (lines, x, y, visited, result) ->
      return if lines[y][x] == '#'
      return if visited["#{x}:#{y}"]?

      visited["#{x}:#{y}"] = true
      result.push(new Backbone.Model({
        id    : "floor-#{x}-#{y}"
        type  : 'floor'
        x     : x
        y     : y
        origX : x
        origY : y
      }))
      @_createFloors(lines, x+1, y, visited, result)
      @_createFloors(lines, x-1, y, visited, result)
      @_createFloors(lines, x, y+1, visited, result)
      @_createFloors(lines, x, y-1, visited, result)

    _objectAt: (objs, x, y) ->
      _.find(objs, (obj) -> obj.attributes.x == x and obj.attributes.y == y)

    movePlayer: (deltaX, deltaY) ->
      p  = @attributes.player
      x1 = p.attributes.x + deltaX
      y1 = p.attributes.y + deltaY

      # Blocked by a wall?
      return if @_objectAt(@attributes.walls, x1, y1)

      # Blocked by a box?
      box = @_objectAt(@attributes.boxes, x1, y1)
      if box?
        x2 = x1 + deltaX
        y2 = y1 + deltaY
        return if @_objectAt(@attributes.walls, x2, y2)
        return if @_objectAt(@attributes.boxes, x2, y2)
        box.set({ x: x2, y: y2 })
        @_computeCompleted()

      p.set({ x: x1, y: y1 })

      @attributes.history.push({
        deltaX : deltaX
        deltaY : deltaY
        box    : box
      })

    undoLastMove: ->
      return if @attributes.history.length == 0

      a    = @attributes
      move = a.history.pop()
      a.player.set({
        x : a.player.attributes.x - move.deltaX
        y : a.player.attributes.y - move.deltaY
      })
      if move.box?
        move.box.set({
          x : move.box.attributes.x - move.deltaX
          y : move.box.attributes.y - move.deltaY
        })
        @_computeCompleted()

    _computeCompleted: ->
      allPoints = (objs) -> 
        _.reduce(
          objs,
          (result, obj) -> result["#{obj.attributes.x},#{obj.attributes.y}"] = true; result
          {}
        )
      gps = allPoints(@attributes.goals)
      bps = allPoints(@attributes.boxes)
      @set('completed', _.size(_.pick(gps, (v,k) -> bps[k])))

    isFinished: ->
      @attributes.completed == @attributes.goals.length

    reset: ->
      # Move objects back to original positions
      for obj in @attributes.boxes.concat([@attributes.player])
        obj.set({
          x : obj.attributes.origX
          y : obj.attributes.origY
        })

      # Reset metadata
      @set('history', [])
      @_computeCompleted()
