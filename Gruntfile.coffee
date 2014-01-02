# Optimization
# ============

# This gruntfile defines an "optimize" task which produces optimized 
# javascript for the entire app, all squished into "build/js/index.min.js".
# The server can be configured to serve the optimized js by setting 
# NODE_ENV=production first (note however that you must run the grunt
# optimize task before doing this).

module.exports = (grunt) ->
  grunt.initConfig({
    clean:
      'optimize': ['build/optimize/']

    coffee: 
      optimize:
        options:
          bare : true
        files: [{
          expand : true
          cwd    : 'public/'
          src    : ['**/*.coffee']
          dest   : 'build/optimize/'
          ext    : '.js'
        }]

    copy:
      'optimize-bower':
        files: [{
          expand : true
          cwd    : 'bower_components/'
          src    : ['**/*.js']
          dest   : 'build/optimize/js/lib/'
        }]
      'optimize-templates':
        files: [{
          expand : true
          cwd    : 'public/templates/'
          src    : ['**']
          dest   : 'build/optimize/templates/'
        }]
      'optimize-post':
        src: '/'

    requirejs:
      optimize:
        options:
          baseUrl        : 'build/optimize/'
          mainConfigFile : "build/optimize/js/require-conf.js",
          out            : "build/js/index.min.js"
          name           : 'js/app'
  })

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-requirejs')

  grunt.registerTask('optimize', [
    'clean:optimize'
    'coffee:optimize'
    'copy:optimize-bower'
    'copy:optimize-templates'
    'requirejs:optimize'
    'clean:optimize'
  ])
