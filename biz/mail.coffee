_api = require './api'
_moment = require 'moment'
_child = require 'child_process'
_async = require 'async'

_records = require './records'
_mrecords = require './m_records'
_browser = require './browser'
_flash = require './flash'

request = require 'request'


sendMail = (title, text, address)->

  request.post({
    url: "http://10.1.172.58:8889/api/message/email"
    headers: 
      private_token: '9cb312d0-14d1-11e5-b79b-bfa179cfc352'
    formData: 
      to: address
      subject: title
      text: text
  })



#发送M站数据给email
exports.reportMobile = ()->
  req = 
    query:
      time_start: _moment().subtract(7,'day').startOf('day').valueOf()
      time_end: _moment().startOf('day').valueOf() + 1
      type: 'day'

  address = '01926@mgtv.com'
  
  _mrecords.getMRecords req, null, (err, result)->
    text = "<table style='border-top:1px solid;border-left:1px solid;border-spacing:0;'><tr>
    <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>日期</td>
    <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>PV-全部</td>
    <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>UV-全部</td>
    <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>PV-播放</td>
    <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>UV-播放</td></tr>"

    for item in result
      text += "<tr>
      <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>#{_moment(item.time_start).format('YYYY-MM-DD')}</td>
      <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>#{item.pv_all}00</td>
      <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>#{item.uv_all}00</td>
      <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>#{item.pv}00</td>
      <td style='border-bottom:1px solid;border-right:1px solid;padding:5px;'>#{item.uv}00</td>
      </tr>"
    text += "</table>"

    sendMail "#{_moment().subtract(7,'day').startOf('day').format('YYYY-MM-DD')}到#{_moment().subtract(1,'day').startOf('day').format('YYYY-MM-DD')}M站数据", text, address