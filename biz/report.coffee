_api = require './api'
_moment = require 'moment'
_child = require 'child_process'
_async = require 'async'


_records = require './records'
_mrecords = require './m_records'
_browser = require './browser'
_flash = require './flash'



sendMsg = (title, text)->


  send_options = "{\"text\":\"#{title}\",\"attachments\":[{\"title\":\"\",\"text\":\"#{text}\",\"color\":\"#ffa500\"}]}"

  command = "curl -H \"Content-Type: application/json\" -d '"+send_options+"' \"https://hook.bearychat.com/=bw7by/incoming/088146355989e6687d1d3b35acd608de\" ";

  options =
    env: 'dev',
    maxBuffer: 20 * 1024 * 1024

  exec = _child.exec(command, options);

#发送主站数据给bearyChat
exports.report = ()->
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
      sendMsg "#{_moment().subtract(1,'day').startOf('day').format('YYYY-MM-DD')}主站数据", text
  )


#发送M站数据给bearyChat
exports.reportM = ()->
  req = 
    query:
      time_start: _moment().subtract(1,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() - 1
      type: 'day'

    
  _mrecords.getMRecords req, null, (err, result)->
    text = "资源加载成功率：#{Math.round(result[0].detail/result[0].pv*10000)/100}%\\n"
    text += "PV-VV转化率：#{Math.round((result[0].vv*1 + result[0].app*1)/result[0].pv*10000)/100}%\\n"
    text += "PV-APP转化率：#{Math.round(result[0].app/result[0].pv*10000)/100}%"
    sendMsg "#{_moment().subtract(1,'day').startOf('day').format('YYYY-MM-DD')}M站数据", text

#发送M站数据给bearyChat
exports.reportPlayer = ()->
  req = 
    query:
      time_start: _moment().subtract(1,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() - 1
      type: 'day'

    
  _flash.getFlashRecords req, null, (err, result)->
    console.log result
    text = "PV-VV转化率：#{Math.round(result[0].vv/result[0].pv*10000)/100}%\\n"
    text += "PV-播放器加载流失率：#{Math.round((result[0].pv-result[0].flash_load)/result[0].pv*10000)/100}%\\n"
    text += "播放器加载-CMS流失率：#{Math.round((result[0].flash_load-result[0].cms)/result[0].pv*10000)/100}%\\n"
    text += "CMS-分发流失率：#{Math.round((result[0].cms-result[0].dispatch)/result[0].pv*10000)/100}%\\n"
    text += "分发-广告开始流失率：#{Math.round((result[0].dispatch-result[0].ad)/result[0].pv*10000)/100}%\\n"
    text += "广告开始-广告结束流失率：#{Math.round((result[0].ad-result[0].ad_end)/result[0].pv*10000)/100}%\\n"
    text += "广告结束-VV流失率：#{Math.round((result[0].ad_end-result[0].vv)/result[0].pv*10000)/100}%\\n"
    sendMsg "#{_moment().subtract(1,'day').startOf('day').format('YYYY-MM-DD')}PV-VV流失率", text

