qiniu = require "qiniu"
crypto = require "crypto"

module.exports = class Uploader

  constructor: (cfg) ->
    qiniu.conf.ACCESS_KEY = cfg.ak
    qiniu.conf.SECRET_KEY = cfg.sk

    @domain = cfg.domain
    @bucket = cfg.bucket
    @token = @getToken()

  getToken: () ->
    putPolicy = new qiniu.rs.PutPolicy(@bucket)
    return putPolicy.token()

  getKey: (buffer) ->
    fsHash = crypto.createHash('md5')
    fsHash.update(buffer)
    return fsHash.digest('hex')

  upload: (buffer, ext, callback) ->
    key = @getKey(buffer)
    filename = key
    filename += ".#{ext}" if typeof ext is 'string' and ext

    qiniu.io.put @token, "#{filename}" , buffer, null, (err, ret) =>
      if !err
        #console.log(ret.key, ret.hash)
        callback(null, {ret: ret, url:"#{@domain}/#{ret.key}"})
      else
        #console.log(err)
        callback(err)
