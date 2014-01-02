requirejs.config {
  baseUrl: ''
}

require ['js/require-conf'], ->
  # Additional dependencies needed by tests.
  requirejs.config {
    paths: {
      'js/lib/chai'  : 'js/lib/chai/chai'
      'js/lib/mocha' : 'js/lib/mocha/mocha'
    }
    shim: {
      'js/lib/mocha' : {
        exports : 'mocha'
      }
    }
  }

  require [
    'js/lib/mocha'
  ], (
    mocha
  ) ->
    mocha.setup('bdd')

    require [
      'js/test/models/board-model-test'
    ], ->
      mocha.run()
