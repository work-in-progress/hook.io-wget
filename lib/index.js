(function() {
  var Hook, Wget, async, colors, httpget, util;
  Hook = require('hook.io').Hook;
  util = require('util');
  colors = require('colors');
  async = require('async');
  httpget = require('http-get');
  Wget = exports.Wget = function(options) {
    var self;
    self = this;
    Hook.call(self, options);
    return self.on("hook::ready", function() {
      return self.on("wget::download", function(data) {
        return self._download(data);
      });
    });
  };
  util.inherits(Wget, Hook);
  Wget.prototype._download = function(data) {
    var items;
    console.log("Starting download".cyan);
    return items = [];
  };
}).call(this);
