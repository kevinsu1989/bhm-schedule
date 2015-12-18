_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'

_config = require './config' 
_schedule = require './biz/schedule'

_records = require './biz/records'
_mrecords = require './biz/m_records'
_browser = require './biz/browser'

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
    console.log 'BHM Schedule is running now!'

  

module.exports = (app)->
  console.log "启动中..."
  require('./router').init(app)
  initBijou app
  if process.env.NODE_ENV is 'production'
    _schedule.initSchedule()
    _schedule.initMSchedule()
    _schedule.initReportSchedule()
    _schedule.initPlayerSchedule()
  else
    console.log "现在的环境是#{process.env.NODE_ENV}, 打开定时任务请使用生产环境--NODE_ENV=production".red

    # _schedule.initReportSchedule()
  # _records.calculateRecordsByTime 1444258799999, 1449138913646, 'hour', (err, result)->
  # _browser.calculateBrowserRecords 1449514800000, 1449536400000, 'hour', (err, result)->

  # _mrecords.calculateRecordsByTime 1447603200000, 1447689600000, 'day', (err, result)->



