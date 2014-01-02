module.exports = (app) ->
  app.configure 'development', ->
    app.get '/', (req, res) ->
      res.render('index', { main: 'js/index.js' })

    app.get '/test', (req, res) ->
      res.render('test')

  app.configure 'production', ->
    app.get '/', (req, res) ->
      res.render('index', { main: 'js/index.min.js' })

  require('./api')(app)
