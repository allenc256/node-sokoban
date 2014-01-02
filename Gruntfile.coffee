module.exports = (grunt) ->
  grunt.initConfig({
    coffee: 
      compile:
        options:
          bare      : true
        files: [{
          expand : true
          cwd    : 'public/'
          src    : ['**/*.coffee']
          dest   : 'compiled/'
          ext    : '.js'
        }]

    # requirejs:
    #   compile:
    #     options:
    #       baseUrl        : 'build/'
    #       mainConfigFile : "build/js/require-conf.js",
    #       out            : "build/optimized.js"
    #       name           : 'js/index'
  })

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-requirejs')
