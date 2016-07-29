_path = require 'path'
_bijou = require 'bijou'
_async = require 'async'
_ = require 'lodash'

_config = require './config' 
_schedule = require './biz/schedule'

_records = require './biz/records'
_mrecords = require './biz/m_records'
_browser = require './biz/browser'
_flash = require './biz/flash'
_report = require './biz/report'

_moment = require 'moment'

# _pageres = require 'pageres'
# _fs = require 'fs-extra'
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
    # _schedule.initSchedule()
    _schedule.initMSchedule()
    # _schedule.initReportSchedule()
    # _schedule.initPlayerSchedule()
    # _schedule.initMobileMailSchedule()
  else
    console.log "现在的环境是#{process.env.NODE_ENV}, 打开定时任务请使用生产环境--NODE_ENV=production".red
    
    # _schedule.initMobileMailSchedule()
    # pageres = new _pageres({delay: 10})
    # .src('192.168.8.66:8200/playerLoad', ['1920x1080'], {crop: true})
    # .dest(__dirname)
    # .run()
    # .then(()-> console.log('done'));
    # _schedule.initSchedule()
    # _schedule.initMSchedule()
    # time_start = _moment().subtract(1,'hour').startOf('hour').valueOf()
    # time_end = _moment().startOf('hour').valueOf()
    # _records.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->

    # _report.report()
    # _flash.calculateRecordsByTime 1461268800000, 1461319200000, 'hour', (err, result)->
    # _records.calculateRecordsByTime 1461268800000, 1461319200000, 'hour', (err, result)->
    # _browser.calculateBrowserRecords 1461268800000, 1461319200000, 'hour', (err, result)->
    # _mrecords.calculateRecordsByTime 1461268800000, 1461319200000, 'hour', (err, result)->



