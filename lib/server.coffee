express = require 'express'
path    = require 'path'

app = express()

app.configure 'development', ->
  # Coffeescript compiler
  app.use('/js', require('connect-coffee-script')({
    src           : 'public/js/'
    dest          : 'build/js/'
    sourceMap     : true
    sourceMapRoot : '/js'
  }))

  # Source map lookups/debugging
  app.use('/js', express.static('public/js'))

app.use('/js', express.static('build/js'))
app.use('/js/lib', express.static('bower_components'))
app.use('/', express.static('public/'))

app.engine('handlebars', require('express3-handlebars')())
app.set('views', 'views')
app.set('view engine', 'handlebars')

require('./routes')(app)

module.exports = app
