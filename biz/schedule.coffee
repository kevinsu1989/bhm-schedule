_schedule = require 'node-schedule'
_api = require './api'
_moment = require 'moment'
_child = require 'child_process'
_async = require 'async'


_records = require './records'
_mrecords = require './m_records'
_browser = require './browser'
_flash = require './flash'



#发送主站数据给bearyChat
report = ()->
  pages = ['首页', '底层', '电视剧', '综艺']
  req = 
    query:{
      time_start: _moment().subtract(1,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() - 1
      type: 'day'
      isSpeed: 'true'
    },  
    params:{
      page_name: '底层'
    }
  list = []
  index = 0
  _async.whilst(
    (-> index < pages?.length)
    ((done)->
      page = pages[index++]
      req.params.page_name = page
      _api.getRecordsSplit req, null, (err, result)->
        console.log result
        list.push result.records[0].result
        done null
    )
    ()->
      text = ""
      for record in list
        text += "【#{record.page_name}】\\n"
        text += "播放器加载成功率：#{Math.round(record.flash_percent*10000)/100}%,\\n" if record.flash_percent > 0
        text +="
            白屏时间：#{record.first_paint}ms,
            页面解析：#{record.dom_ready}ms,
            首屏时间：#{record.first_view}ms,
            完全加载：#{record.load_time}ms。\\n
        "
      sendMsg '昨日主站数据', text
  )


#发送M站数据给bearyChat
reportM = ()->
  req = 
    query:
      time_start: _moment().subtract(1,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() - 1
      type: 'day'

    
  _mrecords.getMRecords req, null, (err, result)->
    text = "资源加载成功率：#{Math.round(result[0].detail/result[0].pv*10000)/100}%\\n"
    text += "PV-VV转化率：#{Math.round((result[0].vv*1 + result[0].app*1)/result[0].pv*10000)/100}%\\n"
    text += "PV-APP转化率：#{Math.round(result[0].app/result[0].pv*10000)/100}%"
    sendMsg '昨日M站数据', text



sendMsg = (title, text)->


  send_options = "{\"text\":\"#{title}\",\"attachments\":[{\"title\":\"\",\"text\":\"#{text}\",\"color\":\"#ffa500\"}]}"

  command = "curl -H \"Content-Type: application/json\" -d '"+send_options+"' \"https://hook.bearychat.com/=bw7by/incoming/088146355989e6687d1d3b35acd608de\" ";

  options =
    env: 'dev',
    maxBuffer: 20 * 1024 * 1024

  exec = _child.exec(command, options);



#开启bearyChat报告任务
exports.initReportSchedule = ()->
  rule_day = new _schedule.RecurrenceRule()

  rule_day.hour = 10
  rule_day.minute = 0
  # reportM()
  # report()
  day = _schedule.scheduleJob rule_day, ()->
    report()
    reportM()





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
  rule_day.minute = 15

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
    console.log time_start
    _flash.calculateRecordsByTime time_start, time_end, 'hour', (err, result)->











 