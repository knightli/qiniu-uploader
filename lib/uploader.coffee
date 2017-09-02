qiniu = require "qiniu"
crypto = require "crypto"

module.exports = class Uploader

  constructor: (cfg) ->
    @mac = new qiniu.auth.digest.Mac(cfg.ak,cfg.sk)
    @domain = cfg.domain
    @bucket = cfg.bucket
    @token = @getToken()

  getToken: () ->
    options = {scope:@bucket}
    putPolicy = new qiniu.rs.PutPolicy(options)
    return putPolicy.uploadToken(@mac)

  getKey: (buffer) ->
    fsHash = crypto.createHash('md5')
    fsHash.update(buffer)
    return fsHash.digest('hex')

  upload: (buffer, ext, callback) ->
    key = @getKey(buffer)
    filename = key
    filename += ".#{ext}" if typeof ext is 'string' and ext

    config = new qiniu.conf.Config()
    formUploader = new qiniu.form_up.FormUploader(config);

    formUploader.put @token, "#{filename}" , buffer, null, (respErr, respBody, respInfo) =>
      if !respErr
        #console.log(ret.key, ret.hash)
        callback(null, {ret: respBody, url:"#{@domain}/#{respBody.key}"})
      else
        #console.log(err)
        callback(err)
