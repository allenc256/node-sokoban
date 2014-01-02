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
