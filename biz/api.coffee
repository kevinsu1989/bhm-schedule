#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:
_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_ip = require 'lib-qqwry'
_fs = require 'fs-extra'
_request = require 'request'


devideRecordsByTime = (records, data)->
  recordsArr = []
  timestamp = parseInt(data.time_start) + parseInt(data.timeStep)
  timeRecords = {
    time_start: data.time_start
    time_end: timestamp
    records: []
  }
  for rec in records
    if parseInt(rec.timestamp) < timestamp && rec isnt records[records.length - 1]
      timeRecords.records.push rec
    else
      if rec is records[records.length - 1] && parseInt(rec.timestamp) < timestamp
        timeRecords.records.push rec
      recordsArr.push({
        time_start: timeRecords.time_start
        time_end: timeRecords.time_end
        records: timeRecords.records
      })
      # 当两条数据时间间隔大于一个时间段时，需要插入空白数据
      total = Math.floor((rec.timestamp - timestamp)/data.timeStep)
      for index in [0...total]
        recordsArr.push({
          time_start: parseInt(timestamp) + index * data.timeStep
          time_end: parseInt(timestamp) + (index + 1)* data.timeStep
          records:[]
        })
      
      timeRecords = {
        time_start: parseInt(timestamp) + total * data.timeStep
        time_end: parseInt(timestamp) + (total + 1) * data.timeStep
        records:[rec]
      }
      timestamp += data.timeStep * (total + 1)
  #补全最后一条数据到时间终点的空白
  leftTime = Math.floor((data.time_end - timestamp)/data.timeStep)
  for index in [0...leftTime]
    recordsArr.push({
      time_start: parseInt(timestamp) + index * data.timeStep
      time_end: parseInt(timestamp) + (index + 1)* data.timeStep
      records:[]
    })
  
  recordsArr

# 计算平均值
calculateRecords = (records)->
  result = {
    first_paint: 0
    first_view: 0
    dom_ready: 0
    load_time: 0
    flash_load: 0
    pv_cal: 0 #参与计算的数据
    pv: 0 #总数据
  }
  return result if !records || records.length is 0
  for record in records
    if 0 < record.load_time < 300000
      result.first_paint += parseInt(record.first_paint)
      result.first_view += parseInt(record.first_view)
      result.dom_ready += parseInt(record.dom_ready)
      result.load_time += parseInt(record.load_time)
      result.pv_cal += 1 
    result.flash_load += record.flash_flag

  
  if result.pv_cal > 0
    result = {
      first_paint: result.first_paint / result.pv_cal
      first_view: result.first_view / result.pv_cal
      dom_ready: result.dom_ready / result.pv_cal
      load_time: result.load_time / result.pv_cal
      flash_load: result.flash_load
      pv_cal: result.pv_cal
      pv: records.length
    }
  result

makeCalculatedRecords = (result)->        
  records = []
  flash_load = flash_count = pv_cal = pv_count = js_count = js_load = 0
  for record in result
    # console.log record
    records.push 
      time_start: record.time_start
      time_end: record.time_end
      result: record
    pv_count += record.pv * 1
    pv_cal += record.pv_cal 

    flash_count += record.flash_count
    flash_load += record.flash_percent * record.flash_count

    js_count += record.js_count
    js_load += record.js_load * record.js_count

  js_load = js_load / js_count
  js_load = 1 if js_load is 0
  flash_load = flash_load / flash_count
  {
    records: records
    pv_count: pv_count
    pv_cal: pv_cal
    flash_count: flash_count
    flash_load: flash_load
    js_count: js_count
    js_load: js_load
  }

# 最终返回结果拼接
getReturns = (records, browser, pv_count, pv_cal, flash_load, flash_count, js_load, js_count)->

  result = {
    first_paint: 0
    first_view: 0
    dom_ready: 0
    load_time: 0
    flash_load: 0
    flash_count: 0
    pv: pv_count
    records: records
    browser: browser
  }

  # 计算所有数据的平局值
  if records
    for record in records
      result.first_paint += record.result.first_paint * record.result.pv_cal / pv_cal
      result.first_view += record.result.first_view * record.result.pv_cal / pv_cal
      result.dom_ready += record.result.dom_ready * record.result.pv_cal / pv_cal
      result.load_time += record.result.load_time * record.result.pv_cal / pv_cal
      result.flash_load += record.result.flash_load
  result.flash_load_1 = result.flash_load / pv_count
  result.flash_load = flash_load
  result.flash_count = flash_count
  result.js_load = js_load
  result.js_count = js_count
  result


exports.getRecords = (req, res, cb)->
  data = req.query
  _entity.records.findRecords data, (err, records)->
    result = calculateRecords records
    cb {
      time_start: data.time_start
      time_end: data.time_end
      result: result
    }



exports.getRecordsSplit = (req, res, cb)->
  data = req.query
  data.page_name = req.params.page_name
  data.time_start = _common.getDayStart().valueOf() if !data.time_start
  data.time_end = _common.getDayStart().valueOf() + 24 * 60 * 60 * 1000 - 1  if !data.time_end
  data.timeStep = 24 * 60 * 60 * 10 if !data.timeStep
  # 最小时间间隔1分钟
  data.timeStep = 60 * 1000 if data.timeStep < 60 * 1000

  queue = [] 
  pv_count = 0
  pv_cal = 0
  flash_load = 0
  flash_count = 0
  js_load = 0
  js_count = 0
  # 用户要求快速查询时，进行快速查询
  if data.isSpeed is 'true'    
    queue.push((done)->
      _entity.records_calculated.findRecords data, (err, result)->
        result = makeCalculatedRecords result

        flash_load = result.flash_load
        flash_count = result.flash_count

        pv_cal = result.pv_cal
        pv_count = result.pv_count

        js_count = result.js_count
        js_load = result.js_load

        done err, result.records, data
    )
    # queue.push((records, data, done)->
    #   _entity.browser_calculated.findRecords data, (err, result)->
    #     for record in records
          
    #     done null, records, data
    # )
    queue.push((records, data, done)->
      _entity.browser_calculated.findSumRecords data, (err, result)->
        done null, records, result
    )
  else 
    queue.push((done)->
      _entity.records.findRecords data, (err, result)->
        pv_count = result?.length || 0
        done err, result, data
    )

    queue.push((records, data, done)->
      recordsArr = devideRecordsByTime records, data
      for records in recordsArr
        records.result = calculateRecords records.records
        pv_cal += records.result.pv_cal
        delete records.records 
      done null, recordsArr, data
    )

    queue.push((records, data, done)->
      _entity.records.getFlashLoadCount data, (err, result)->
        if result.length > 1
          flash_count = result[0].count * 1 + result[1].count * 1 
        else if result.length is 1
          flash_count = result[0].count * 1
        flash_load = (result[1].count * 1) /flash_count if result.length > 1
        flash_load = 1 if result.length and result[0].flash_load is 1
        done null, records, data
    )

    queue.push((records, data, done)->
      _entity.records.getJsLoad data, (err, result)->
        if result.length > 1
          js_count = result[0].count * 1 + result[1].count * 1 
        else if result.length is 1
          js_count = result[0].count * 1
        js_load = (result[1].count * 1) /js_count if result.length > 1
        js_load = 1 if result.length and result[0].js_load is 1
        done null, records, data
    )

    queue.push((records, data, done)->
      _entity.records.findPVRecords data, (err, result)->
        pv_count = ~~result[0]?.pv
        done null, records, data
    )

    queue.push((records, data, done)->
      _entity.records.browserPercent data, (err, result)->
        done null, records, result
    )

  _async.waterfall queue,(err, records, browser)->
    cb err, getReturns(records, browser, pv_count, pv_cal, flash_load, flash_count, js_load, js_count)



exports.getPages = (req, res, cb)->
  _entity.page.findPages (err, result)->
    pages = [];
    for item in result 
      if item.parent is 0
        item.children = []
        pages.push(item) 

    for page in pages
      for item in result 
        page.children.push(item) if item.parent is page.id

    cb err, pages

exports.getIp = ()->

  queue = [] 
  queue.push((done)->
    _entity.records.getIp (err, result)->
      done err, result
  )
  _async.waterfall queue,(err, list)->
    ipArr = []

    for item in list
      ip = _ip.intToIP item.ip
      # _request "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=#{ip}", (err, response, result)-> 
      #   console.log response
      ipArr.push 
        ip: ip
        count: item.c
        # url: item.url
      # console.log ip
    _fs.writeFile 'time_count_top100.text', JSON.stringify(ipArr)

  

