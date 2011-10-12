vows = require 'vows'
assert = require 'assert'
nock = require 'nock'

main = require '../lib/index'

specHelper = require './spec_helper'


            
# Please note that the specs here are mimicing a real use case,
# hence the namespacing with : and stuff.

vows.describe("integration_task")
  .addBatch
    "SETUP HOOK" :
      topic: () -> 
        specHelper.setup @callback
        return
      "THEN IT SHOULD SET UP :)": () ->
        assert.isTrue true
  .addBatch 
    "WHEN creating a task container without tasks and we call getTasks": 
      topic:  () ->
        specHelper.hook.on "wget::download-complete", (data) =>
          @callback(null,data)
        specHelper.hook.emit "wget::download",
          url : specHelper.requestUrl + specHelper.goodPath
          target : "tmp/test1.txt" # Get some tmp filename here
        return
      "THEN it must not fails": (err,data) ->
        assert.isNull err
  .export module
