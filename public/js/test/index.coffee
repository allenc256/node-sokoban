require [
  'js/lib/mocha'
], (
  mocha
) ->
  mocha.setup('bdd')

  require [
    'test/models/board-model-test'
  ], ->
    mocha.run()
