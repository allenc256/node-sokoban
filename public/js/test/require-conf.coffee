# Additional dependencies needed by tests.
requirejs.config {
  paths: {
    'lib/chai'  : 'lib/chai/chai'
    'lib/mocha' : 'lib/mocha/mocha'
  }
  shim: {
    'lib/mocha' : {
      exports : 'mocha'
    }
  }
}
