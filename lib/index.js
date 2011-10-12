(function() {
  var Hook, Wget, colors, httpget, util;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Hook = require('hook.io').Hook;
  util = require('util');
  colors = require('colors');
  httpget = require('http-get');
  require('pkginfo')(module, 'version', 'hook');
  Wget = exports.Wget = function(options) {
    var self;
    self = this;
    Hook.call(self, options);
    return self.on("hook::ready", function() {
      var download, head, _i, _j, _len, _len2, _ref, _ref2, _results;
      self.on("wget::download", function(data) {
        return self._download(data);
      });
      self.on("wget::head", function(data) {
        return self._head(data);
      });
      _ref = self.downloads || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        download = _ref[_i];
        self.emit("wget::download", {
          url: download.url,
          target: download.target
        });
      }
      _ref2 = self.heads || [];
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        head = _ref2[_j];
        _results.push(self.emit("wget::head", {
          url: head.url
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
          error: err,
          head: false
        });
      } else {
        console.log(result);
        return this.emit("wget::download-complete", {
          code: result.code,
          pathToFile: result.file != null ? result.file : null,
          headers: result.headers,
          requestedUrl: data.url,
          result: result
        });
      }
    }, this));
  };
  Wget.prototype._head = function(data) {
    var options;
    console.log(("Obtaining head for " + data.url).cyan);
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
    return httpget.head(options, __bind(function(err, result) {
      if (err) {
        console.error(err);
        return this.emit("wget::error", {
          error: err,
          head: true
        });
      } else {
        console.log(result);
        return this.emit("wget::head-complete", {
          code: result.code,
          headers: result.headers,
          requestedUrl: data.url,
          downloadedUrl: result.url != null ? result.url : data.url,
          result: result
        });
      }
    }, this));
  };
}).call(this);
