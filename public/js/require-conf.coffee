# RequireJS config. This is factored out into a separate file so that 
# the "/test" page can depend on it.

requirejs.config {
  baseUrl: ''
  paths: {
    'hbs'             : 'js/lib/require-handlebars-plugin/hbs'
    'js/lib/lodash'   : 'js/lib/lodash/dist/lodash.compat'
    'js/lib/jquery'   : 'js/lib/jquery/jquery'
    'js/lib/backbone' : 'js/lib/backbone/backbone'
    'js/lib/q'        : 'js/lib/q/q'
  }
  shim: {
    'js/lib/backbone' : {
      deps    : ['js/lib/lodash', 'js/lib/jquery']
      exports : 'Backbone'
    }
    'js/lib/lodash' : {
      exports : '_'
    }
    'js/lib/jquery' : {
      exports: '$'
    }
  }
  hbs: {
    templateExtension: 'handlebars'
  }
}
