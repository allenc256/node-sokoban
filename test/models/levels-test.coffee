assert = require 'assert'
_      = require 'lodash'

levels = require '../../lib/models/levels'

describe 'lib/models/levels', ->
  it 'parsePack works', ->
    result = levels.parsePack([
      '; Some name'
      '; ...extraneous comments...'
      '; Copyright: Some author'
      '; ...extraneous comments...'
      ''
      '#'
      '; First board'
      ''
      '#  '
      ' # '
      '  #'
      '; Second board'
      ''
      ''
      '#'
      ''
      '; Third board'
      '; ...extraneous comments...'
    ])

    expected = {
      name   : 'Some name'
      author : 'Some author'
      levels : [
        { name: 'First board', lines: ['#'] }
        { name: 'Second board', lines: ['#  ', ' # ','  #' ] }
        { name: 'Third board', lines: ['#'] }
      ]
    }

    assert.deepEqual(expected, result)

  verifyMicroban = (pack) ->
    assert.equal('Microban', pack.name)
    assert.equal('David W Skinner', pack.author)
    assert.equal(155, _.size(pack.levels))
    level142 = _.find(pack.levels, (l) -> l.name == '142')
    lines = [
      '  ####',
      '  #  #',
      '  #  ####',
      '###$.$  #',
      '#  .@.  #',
      '#  $.$###',
      '####  #',
      '   #  #',
      '   ####'
    ]
    assert.deepEqual(lines, level142.lines)

  it 'loadPack works', (done) ->
    levels.loadPack(__dirname + '/../../levels/microban.txt')
    .done (pack) ->
      verifyMicroban(pack)
      done()
