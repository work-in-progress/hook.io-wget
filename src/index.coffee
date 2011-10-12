Hook = require('hook.io').Hook
util = require('util')
colors = require('colors')    
httpget = require 'http-get'
url = require 'url'

require('pkginfo')(module,'version','hook')
  
Wget = exports.Wget = (options) ->
  self = @
  Hook.call self, options
  
  self.on "hook::ready", ->  
  
    self.on "wget::download", (data)->
      self._download(data)

    self.on "wget::head", (data)->
      self._head(data)
      
    for download in (self.downloads || [])
      self.emit "wget::download",
        url : download.url
        target : download.target

    for head in (self.heads || [])
      self.emit "wget::head",
        url : head.url
    
util.inherits Wget, Hook

Wget.prototype._buildRequestOptions = (data) ->
  options =
    url : data.url

  # Need to check if the extence op is really necessary. 
  options.headers = if data.headers? data.headers else {}
  options.nogzip = data.nogzip if data.nogzip?
  options.proxy = data.proxy if data.proxy?
  options.redirects = data.redirects if data.redirects?
  
  # Hardcore auth fix
  parsed = url.parse(data.url)
  if parsed.auth
    auth64 = new Buffer("#{parsed.auth}","utf8").toString('base64')  
    options.headers['Authorization'] = "Basic #{auth64}"

    options.url = url.format
      protocol : parsed.protocol
      hostname :parsed.hostname
      port : parsed.port
      pathname :parsed.pathname
      search :parsed.search
      fragment :parsed.fragment
      
    #console.log "PARSED #{options.url}"
  
  options

Wget.prototype._download = (data) ->
  console.log "Starting download #{data.url} to #{data.target}".cyan
  
  options = @_buildRequestOptions data
  console.log options
  
  httpget.get options ,data.target, (err,result) =>
    if err
      console.error err
      @emit "wget::error", 
        error : err
        head : false
    else
      console.log result
      @emit "wget::download-complete", 
        code : result.code
        pathToFile : if result.file? then result.file else null
        #buffer : if result.buffer? result.buffer else null
        headers : result.headers
        requestedUrl : data.url
        result : result


Wget.prototype._head = (data) ->
  console.log "Obtaining head for #{data.url}".cyan
  
  options = @_buildRequestOptions data
  console.log options
  
  httpget.head options , (err,result) =>
    if err
      console.error err
      @emit "wget::error", 
        error : err
        head : true
    else
      console.log result
      @emit "wget::head-complete", 
        code : result.code
        headers : result.headers
        requestedUrl : data.url
        downloadedUrl : if result.url? then result.url else data.url 
        result : result
    