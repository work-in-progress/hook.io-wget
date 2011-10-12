(function() {
  var Hook, Wget, async, colors, httpget, util;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
      var download, _i, _len, _ref, _results;
      self.on("wget::download", function(data) {
        return self._download(data);
      });
      _ref = self.downloads;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        download = _ref[_i];
        _results.push(self.emit("wget::download", {
          url: download.url,
          target: download.target
        }));
      }
      return _results;
    });
  };
  util.inherits(Wget, Hook);
  Wget.prototype._download = function(data) {
    var options;
    console.log(("Starting download " + data.url + " to " + data.target).cyan);
    options = {
      url: data.url
    };
    if (data.headers != null) {
      options.headers = data.headers;
    }
    if (data.nogzip != null) {
      options.nogzip = data.nogzip;
    }
    if (data.proxy != null) {
      options.proxy = data.proxy;
    }
    if (data.redirects != null) {
      options.redirects = data.redirects;
    }
    return httpget.get(options, data.target, __bind(function(err, result) {
      if (err) {
        console.error(err);
        return this.emit("wget::error", {
          error: err
        });
      } else {
        console.log(result);
        return this.emit("wget::download-complete", {
          code: result.code,
          pathToFile: result.file != null ? result.file : null,
          headers: result.headers,
          requestedUrl: data.url,
          downloadedUrl: result.url != null ? result.url : data.url
        });
      }
    }, this));
  };
}).call(this);
