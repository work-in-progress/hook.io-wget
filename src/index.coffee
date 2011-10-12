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
      
    for download in self.downloads
      self.emit "wget::download",
        url : download.url
        target : download.target
    
util.inherits Wget, Hook


Wget.prototype._download = (data) ->
  console.log "Starting download #{data.url} to #{data.target}".cyan
  
  options =
    url : data.url
  
  options.headers = data.headers if data.headers?
  options.nogzip = data.nogzip if data.nogzip?
  options.proxy = data.proxy if data.proxy?
  options.redirects = data.redirects if data.redirects?
  
  httpget.get options ,data.target, (err,result) =>
    if err
      console.error err
      @emit "wget::error", error : err
    else
      console.log result
      @emit "wget::download-complete", 
        code : result.code
        pathToFile : if result.file? then result.file else null
        #buffer : if result.buffer? result.buffer else null
        headers : result.headers
        requestedUrl : data.url
        downloadedUrl : if result.url? then result.url else data.url 
    