main = require '../lib/index'
nock = require 'nock'

module.exports = 
  hook: null
  nocked: null
  currentCb : null
  eatMe : 0
  
  username : "foo"
  password : "bar"

  requestUrlAuth : "http://foo:bar@test.com"
  requestUrl : "http://test.com"
  goodPath: "/goodone.tbz"
  notFoundPath: "/badone.tbz"
    
  setup: (cb) ->
    @nocked = nock(@requestUrl) 
                .get(@goodPath)
                .replyWithFile(200,"#{__dirname}/fixtures/success.txt")
                .get(@notFoundPath)
                .replyWithFile(404,"#{__dirname}/fixtures/notfound.txt")

    @hook = new main.Wget(name: 'wget')
    @hook.onAny (data) =>
      console.log "ANY #{@hook.event} EatMe: #{@eatMe} HasCurrentCb: #{@currentCb != null}"
      if @currentCb
        if @eatMe == 0
          @currentCb null,@hook.event, data
          @currentCb = null
        @eatMe = @eatMe - 1  

    @hook.start()
    cb null,@hook
    
  
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"

  cleanTmpFiles: (fileNames) ->
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore

  # Invoke this in your topic and pass your callback.
  # The cb will be called with: null,event,data
  # we passing null for err as the first parameter to stay true to node.js
  # HookMeUp always eats the first message.
  hookMeUp: (cb) ->
    @currentCb = cb
    @eatMe = 1
