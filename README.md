## About hook.io-wget

A hook to download files through HTTP. Based on the http-get module by Stefan Rusu.

IMPORTANT: THIS IS A WORK IN PROGRESS - IF YOU USE IT FIX THE VERSION - UPDATES WILL BREAK

![Wget Icon](http://github.com/scottyapp/hook.io-wget/raw/master/assets/wget114x114.png)

[![Build Status](https://secure.travis-ci.org/scottyapp/hook.io-wget.png)](http://travis-ci.org/scottyapp/hook.io-wget.png)

Please note that travis-ci.org does not build this correctly because the module requires node v 0.4.11 but travis has 0.4.8 installed at this point.

## Install

npm install -g hook.io-wget

## Usage

	./bin/hookio-wget 

This starts a hook and reads the local config.json. The files found there will be downloaded. A sample is provided in examples/example-config.json. The config
option is included for debugging and testing purposes, in general you will want to use messages and code.s

### Messages

wget::download [in]

	url: the url to download from. Required. Redirects are supported
	target: the target file name. Required.
	headers: Optional headers to pass along. See http-get for details
	nogzip:  Optionally prevents automatic uncompression. See http-get for details
	proxy: Optional proxy settings. See http-get for details
	redirects: Optional max number of redirects. See http-get for details

wget::error [out]

	error: See examples/download-error.txt for content

wget::download-complete [out]

	code : The http code
	pathToFile : The path to the downloaded file
	headers : The headers from the response
	requestedUrl : The originally requested url
	downloadedUrl : The actual url, after redirects

See examples/download-complete.txt

### Hook.io Schema support 

The package config contains experimental hook.io schema definitions. 

### Coffeescript

	hook = require("hook.io-wget").Wget
 
### Javascript

	var hook = require("hook.io-wget").Wget;

## Advertising :)

Check out http://freshfugu.com and http://scottyapp.com

Follow us on Twitter at @getscottyapp and @freshfugu and like us on Facebook please. Every mention is welcome and we follow back.

## Trivia

Listened to lots of Pink while writing this.

## Release Notes

### 0.0.3 (not published yet)

* Added image assets
* exposed version and hook
* removed unnecessary dependencies

### 0.0.2

* Fixed npm dependencies

### 0.0.1

* First version

## Internal Stuff

* npm run-script watch

# Publish new version

* Change version in package.json
* 
* git tag -a v0.0.2 -m 'version 0.0.2'
* git push --tags
* npm publish

## Contributing to hook.io-wget
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Martin Wawrusch. See LICENSE for
further details.


