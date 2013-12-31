define [
  'lib/backbone'
  'lib/jquery'
  'lib/lodash'
  'lib/q'
], (
  Backbone
  $
  _
  Q
) ->
  class AppModel extends Backbone.Model
    loadLevelPacks: ->
      Q($.ajax('/api/levels')).then (packs) =>
        @set('levelPacks', packs)

    loadLevel: (packName, levelNum) ->
      if levelNum > @getMaxOpenableLevel(packName)
        alert("You haven't unlocked this level yet!")
        throw new Error("Level not openable") 

      Q($.ajax("/api/levels/#{encodeURIComponent(packName)}/#{levelNum}")).then (level) =>
        a = @attributes
        packNum = _.findIndex(a.levelPacks, (p) -> p.name == packName)
        @set({
          levelPackNum : packNum
          levelPack    : a.levelPacks[packNum]
          levelNum     : levelNum
          level        : level
        })
        @setLastLevel(packName, levelNum)

    setMaxOpenableLevel: (pack, num) ->
      localStorage["sokoban.maxOpenableLevel:#{pack}"] = num.toString()

    getMaxOpenableLevel: (pack) ->
      parseInt(localStorage["sokoban.maxOpenableLevel:#{pack}"]) || 0

    getLastLevel: -> {
      lastLevelPackName : localStorage["sokoban.lastLevelPackName"]
      lastLevelNum      : localStorage["sokoban.lastLevelNum"]
    }

    setLastLevel: (pack, num) ->
      localStorage["sokoban.lastLevelPackName"] = pack
      localStorage["sokoban.lastLevelNum"]      = num
