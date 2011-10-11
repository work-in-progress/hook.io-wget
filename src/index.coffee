Hook = require('hook.io').Hook
util = require('util')
colors = require('colors')    
async = require 'async'
httpget = require 'http-get'
  
Wget = exports.Wget = (options) ->
  self = @
  Hook.call self, options
  
  self.on "hook::ready", ->  
  
    self.on "wget::download", (data)->
      #console.log JSON.stringify(data.checkResult)
      self._download(data)

util.inherits Wget, Hook


Wget.prototype._download = (data) ->
  console.log "Starting download".cyan
  
  items = []
