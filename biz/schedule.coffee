_schedule = require 'node-schedule'
_api = require './api'
_moment = require 'moment'
_child = require 'child_process'
_async = require 'async'


_records = require './records'
_mrecords = require './m_records'
_browser = require './browser'
_flash = require './flash'
_report = require './report'


_mail = require './mail'




#开启M站邮件报告任务
exports.initMobileMailSchedule = ()->
  rule_week = new _schedule.RecurrenceRule()
  rule_week.dayOfWeek = [new _schedule.Range(4, 4)]
  rule_week.hour = 10
  rule_week.minute = 0
  rule_week = _schedule.scheduleJob rule_week, ()->
    _mail.reportMobile()

#开启bearyChat报告任务
exports.initReportSchedule = ()->
  rule_day = new _schedule.RecurrenceRule()
  rule_day.hour = 10
  rule_day.minute = 0
  day = _schedule.scheduleJob rule_day, ()->
    _report.report()
    _report.reportM()
    _report.reportPlayer()



#开启主站数据计算定时任务
exports.initSchedule = ()->
  rule_backup = new _schedule.RecurrenceRule()
  rule_day = new _schedule.RecurrenceRule()
  rule_hour = new _schedule.RecurrenceRule()

  rule_day.dayOfWeek = [new _schedule.Range(0, 6)]
  rule_day.hour = 3
  rule_day.minute = 30

  rule_backup.dayOfWeek = [1]
  rule_backup.hour = 3
  rule_backup.minute = 30

  rule_hour.minute = 5

  # backup = _schedule.scheduleJob rule_backup, ()->
  #   _records.backUpRecords (err, result)->

  # 每天凌晨3点计算前一天的数据
  day = _schedule.scheduleJob rule_day, ()->
    time_start = _moment().subtract(1,'day').startOf('day').valueOf()
    time_end = _moment().startOf('day').valueOf()
    _browser.calculateBrowserRecords time_start, time_end, 'day', (err, result)->
    setTimeout(()->
      _records.calculateRecordsByTime time_start, time_end, 'day', (err, result)->
    , 30 * 1000)

  # 每小时计算上一小时的数据
  hour = _schedule.scheduleJob rule_hour, ()->
    time_start = _moment().subtract(1,'hour').startOf('hour').valueOf()
    time_end = _moment().startOf('hour').valueOf()
    _browser.calculateBrowserRecords time_start, time_end, 'hour', (err, result)->
    setTimeout(()->
      _records.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->
    , 15 * 1000)



#开启M站数据计算定时任务
exports.initMSchedule = ()->
  rule_day = new _schedule.RecurrenceRule()
  rule_hour = new _schedule.RecurrenceRule()

  rule_day.hour = 3
  rule_day.minute = 13

  rule_hour.minute = 2

  day = _schedule.scheduleJob rule_day, ()->
    time_start = _moment().subtract(1,'day').startOf('day').valueOf()
    time_end = _moment().startOf('day').valueOf()
    _mrecords.calculateRecordsByTime time_start, time_end, 'day', (err, result)->

  hour = _schedule.scheduleJob rule_hour, ()->
    time_start = _moment().subtract(1,'hour').startOf('hour').valueOf()
    time_end = _moment().startOf('hour').valueOf()
    _mrecords.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->




#开启播放器数据计算定时任务
exports.initPlayerSchedule = ()->
  rule_day = new _schedule.RecurrenceRule()
  rule_hour = new _schedule.RecurrenceRule()

  rule_day.hour = 3
  rule_day.minute = 15

  rule_hour.minute = 4


  day = _schedule.scheduleJob rule_day, ()->
    time_start = _moment().subtract(1,'day').startOf('day').valueOf()
    time_end = _moment().startOf('day').valueOf()
    _flash.calculateRecordsByTime time_start, time_end, 'day', (err, result)->

  hour = _schedule.scheduleJob rule_hour, ()->
    time_start = _moment().subtract(1,'hour').startOf('hour').valueOf()
    time_end = _moment().startOf('hour').valueOf()
    _flash.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->











 