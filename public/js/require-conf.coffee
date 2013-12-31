requirejs.config {
  baseUrl: '/js'
  paths: {
    'hbs'          : 'lib/require-handlebars-plugin/hbs'
    'lib/lodash'   : 'lib/lodash/dist/lodash.compat'
    'lib/jquery'   : 'lib/jquery/jquery'
    'lib/backbone' : 'lib/backbone/backbone'
    'lib/q'        : 'lib/q/q'
  }
  shim: {
    'lib/backbone' : {
      deps    : ['lib/lodash', 'lib/jquery']
      exports : 'Backbone'
    }
    'lib/lodash' : {
      exports : '_'
    }
    'lib/jquery' : {
      exports: '$'
    }
  }
  hbs: {
    templateExtension: 'handlebars'
  }
}
