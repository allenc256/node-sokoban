_       = require 'lodash'
Q       = require 'q'
fs      = require 'fs'
path    = require 'path'
winston = require 'winston'

# Assumes level format from this site:
# http://www.sourcecode.se/sokoban/levels

parsePack = (lines) ->
  # Remove empty lines
  lines = _.filter(lines, (l) -> l.trim().length > 0)

  packName   = undefined
  packAuthor = undefined

  # Find name/author
  _.find lines, (l) ->
    packName   ||= /^\s*;\s*(.*)/.exec(l)?[1]
    packAuthor ||= /^\s*;\s*Copyright:\s*(.*)/.exec(l)?[1]
    return /^\s*#/.test(l)

  levels = []
  buffer = []
  for line in lines
    if line.trim().indexOf(';') == 0
      if buffer.length > 0
        name = line.trim().substring(1).trim()
        levels.push({
          name  : name
          lines : _.clone(buffer)
        })
        buffer = []
    else if line.trim().length > 0
      buffer.push(line)

  return {
    name   : packName
    author : packAuthor
    levels : levels
  }

loadPack = (file) ->
  file = path.normalize(file)
  Q.nfcall(fs.readFile, file, 'utf8')
  .then (s) ->
    winston.info("Loading pack '#{file}'")
    parsePack(s.split("\n"))

loadPacks = (files) ->
  result = []
  p      = Q()
  for file in files
    do (file) ->
      name = path.basename(file, '.txt')
      p = p.then -> loadPack(file).then (pack) -> result.push(pack)
  p.then -> result

module.exports = {
  parsePack : parsePack
  loadPack  : loadPack
  loadPacks : loadPacks
}
