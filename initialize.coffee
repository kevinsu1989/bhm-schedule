_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'

_config = require './config' 
_schedule = require './biz/schedule'


#初始化bijou
initBijou = (app)->
  options =
    log: process.env.DEBUG
    #指定数据库链接
    database: _config.database
    #指定路由的配置文件
    routers: []

  _bijou.initalize(app, options)

  queue = []
  queue.push(
    (done)->
      #扫描schema，并初始化数据库
      schema = _path.join __dirname, './schema'
      _bijou.scanSchema schema, done
  )


  _async.waterfall queue, (err)->
    console.log err if err
    console.log 'Monitor Front is running now!'





  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  # _api.getIp()
  # _schedule.initSchedule()
  _schedule.initMSchedule()
  # _schedule.initReportSchedule()
  # _records.calculateRecordsByTime 1446447600000, 1446451200000, 'hour', (err, result)->
  # _browser.calculateBrowserRecords 1446429600000, 1446451200000, 'hour', (err, result)->




