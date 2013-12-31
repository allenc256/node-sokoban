_ = require 'lodash'

levels = require '../../models/levels'

PACKS = _.map([
  'Dimitri-Yorick.txt'
  'microban.txt'
  'sokogen-990602.txt'
  'MiniCosmos.txt'
  'dur02cnt.txt'
  'Boxxle1.txt'
  'Boxxle2.txt'
  'sasquatch.txt'
  'Original.txt'
], (f) -> __dirname + '/../../../levels/' + f)

loadPacks = _.memoize ->
  levels.loadPacks(PACKS).then (packs) ->
    [require('../../../levels/tutorial')].concat(packs)

module.exports = (app) ->
  app.get '/api/levels', (req, res) ->
    loadPacks().done (packs) ->
      res.send(_.map(packs, (p) -> {
        name   : p.name
        author : p.author
        levels : _.pluck(p.levels, 'name')
      }))

  app.get '/api/levels/:pack/:level', (req, res) ->
    loadPacks().done (packs) ->
      pack   = _.find(packs, (p) -> p.name == req.params.pack)
      result = pack?.levels[req.params.level]
      if result? then res.send(result) else res.send(404)
