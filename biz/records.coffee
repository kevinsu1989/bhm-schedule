#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:

_api = require './api'
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'


calculateByTime = (time, page, browser_name, cb)->
  req = {
    query: {
      time_start: time.timeStart,
      time_end: time.timeEnd,
      timeStep: time.timeStep,
      page_like: page.page_like,
    },
    params:{
      page_name: page.page_name
    }
  } 
  req.query.isSpeed = time.isSpeed if time.isSpeed
  req.query.type = 'hour' if time.isSpeed
  
  req.query.browser_name = browser_name if browser_name
  queue = []

  queue.push(
    (done)->
      _api.getRecordsSplit req, null, (err, result)->
        # console.log arguments
        done err, result, time
  )

  queue.push(
    (result, time, done)->
      record = {
        time_start: time.timeStart,
        time_end: time.timeEnd,
        first_paint: result.first_paint,
        first_view: result.first_view,
        dom_ready: result.dom_ready,
        load_time: result.load_time,
        flash_percent: result.flash_load,    
        page_name: page.page_name,
        pv: result.pv,
        flash_count: result.flash_count,
        js_load: result.js_load,
        js_count: result.js_count,
        type: time.timeType,
        first_paint_levels: JSON.stringify(result.records_level.first_paint)
        first_view_levels: JSON.stringify(result.records_level.first_view)
        dom_ready_levels: JSON.stringify(result.records_level.dom_ready)
        load_time_levels: JSON.stringify(result.records_level.load_time)
      }
      if result.records[0]
        record.pv_cal = result.records[0].result.pv_cal
      else
        record.pv_cal = 0
      record.browser_name = browser_name if browser_name
      console.log record
      _entity.records_calculated.saveCalculatedRecords [record], (err, result)->
        done err, result, time
  )
  # queue.push(
  #   (result, time, done)->
  #     records = []
  #     for key of result.records_level
  #       records.push(
  #         time_start: time.timeStart,
  #         time_end: time.timeEnd,
  #         time_type: time.timeType,        
  #         page_name: page.page_name,
  #         name: key,
  #         values: JSON.stringify(result.records_level[key])
  #       )
  # )

  _async.waterfall queue, (err, result)->
    cb err, result



exports.calculateRecordsByHour = ()->
  _entity.page.findPages (err, pages)->
    time = {
      timeStart: _moment().subtract(1,'hour').startOf('hour').valueOf()
      timeEnd: _moment().startOf('hour').valueOf() - 1
      timeStep: 60 * 60 * 1000
      timeType: 'hour'
    }
    browser = ['', 'ie', 'chrome']
    for page in pages
      for browser_name in browser
        calculateByTime time, page, browser_name, (err, result)->



exports.calculateRecordsByTime = (timeStart, timeEnd, timeType)->
  # return null
  timeArr = [{
    timeStart: _moment().subtract(1,'hour').startOf('hour').valueOf()
    timeEnd: _moment().startOf('hour').valueOf() - 1
    timeStep: 60 * 60 * 1000
    timeType: 'hour'
  }]
  timeArr = _common.getSplitTime timeStart, timeEnd, timeType if timeStart && timeEnd && timeType
  _entity.page.findPages (err, pages)->
    browser = [null, 'ie', 'chrome']
    for time, index in timeArr
      ((time)->
        setTimeout(()->
          for page, pindex in pages
            if timeType is 'day'
              time.isSpeed = 'true'
              time.timeEnd += 2
              for browser_name in browser
                calculateByTime time, page, browser_name, (err, result)->
            else
              for browser_name in browser
                calculateByTime time, page, browser_name, (err, result)->
              
        , index * 120 * 1000)
      )(time)



  

exports.backUpRecords = ()->
  console.log "开始备份#{_moment().startOf('week').format('YYYYMMDD')}到#{_moment().subtract(1,'day').format('YYYYMMDD')}的数据"
  _entity.records_history.saveHistoryRecords (err, result)->
    console.log "备份完成"
    done err, result

