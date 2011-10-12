main = require '../lib/index'
nock = require 'nock'

module.exports = 
#  database : dbUrl
  hook: null
  nocked: null
  
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

    @hook.start()
    cb null,@hook
    
  
  # Connect to the test database.
###
  connectDatabase: () ->
    mongoose.connect dbUrl
    
  cleanDatabase : (cb) ->
    databaseCleaner = new DatabaseCleaner('mongodb')
    databaseCleaner.clean mongoose.createConnection(dbUrl).db, (err) ->
      return cb err if e?
      cb null
      
###
