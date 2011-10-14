vows = require 'vows'
assert = require 'assert'
nock = require 'nock'

main = require '../lib/index'

specHelper = require './spec_helper'

# TODO: More Specs
# TODO: Actually check that the correct stuff has been downloaded.
vows.describe("integration_task")
  .addBatch
    "CLEANUP TEMP":
      topic: () ->
        specHelper.cleanTmpFiles ['test1.txt']
      "THEN IT SHOULD BE CLEAN :)": () ->
        assert.isTrue true        
  .addBatch
    "SETUP HOOK" :
      topic: () -> 
        specHelper.setup @callback
        return
      "THEN IT SHOULD SET UP :)": () ->
        assert.isTrue true
  .addBatch 
    "WHEN sending the download message": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.emit "wget::download",
          url : specHelper.requestUrl + specHelper.goodPath
          target : specHelper.tmpPath("test1.txt")
        return
      "THEN it must receive the download complete event": (err,event,data) ->
        assert.equal event,"wget::download-complete" 
  .export module
