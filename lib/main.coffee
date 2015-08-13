Uploader = require('./uploader');

{CompositeDisposable} = require 'atom'

module.exports =
  config:
    qiniuAK:
      title: "qiniuAK"
      type: 'string'
      description: "在七牛后台 “账号设置 - 密钥” 下查看 AK 和 SK 的值"
      default: ""
    qiniuSK:
      title: "qiniuSK"
      type: 'string'
      description: "在七牛后台 “账号设置 - 密钥” 下查看 AK 和 SK 的值"
      default: ""
    qiniuBucket:
      title: "qiniuBucket"
      type: 'string'
      description: "在七牛后台 “选择一个空间” 下找一个空间名称"
      default: ""
    qiniuDomain:
      title: "qiniuDomain"
      type: 'string'
      description: "在七牛后台指定空间下 “空间设置 - 域名设置” 下查看空间绑定的域名"
      default: ""

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'qiniu-uploader:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  # `instance`:
  # API for markdown-assistant.
  # should return an uploader instance which has upload API
  #
  # usage:
  #   instance().upload(imagebuffer, '.png', (err, retData)->)
  #   * retData.url should be the online url
  instance: ->
    ak = atom.config.get('qiniu-uploader.qiniuAK')
    sk = atom.config.get('qiniu-uploader.qiniuSK')
    bucket = atom.config.get('qiniu-uploader.qiniuBucket')
    domain = atom.config.get('qiniu-uploader.qiniuDomain')?.trim()

    if domain?.indexOf('http') < 0
      domain = "http://#{domain}"

    return unless ak && sk && bucket && domain

    cfg = {
      ak: ak,
      sk: sk,
      bucket: bucket,
      domain: domain
    }
    return new Uploader(cfg)
