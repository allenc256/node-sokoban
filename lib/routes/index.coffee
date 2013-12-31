module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render('index')

  app.get '/test', (req, res) ->
    res.render('test')

  require('./api')(app)
