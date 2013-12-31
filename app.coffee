require 'coffee-errors'

winston = require 'winston'
app     = require './lib/server'

winston.cli()

process.on 'uncaughtException', (err) ->
  winston.error("Uncaught exception: #{err}", err)
  process.exit(1)

port = process.env.PORT || 3000
app.listen(port)
winston.info("Server listening on #{port}")
