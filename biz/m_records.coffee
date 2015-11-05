_ = require 'lodash'
_async = require 'async'
_http = require('bijou').http
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'


calculateByTime = (time, cb)->
  query =
    time_start: time.timeStart
    time_end: time.timeEnd
    time_type: time.timeType


  queue = []

  queue.push(
    (done)->
      _entity.m_records.getRecords query, (err, result)->
        console.log arguments
        done err, result
  )

  queue.push(
    (result, done)->
      console.log result
      _entity.m_records_calculated.addRecords result, (err, result)->
        done err, result
  )
  
  _async.waterfall queue, (err, result)->
    cb err, result
  


exports.calculateRecordsByTime = (timeStart, timeEnd, timeType)->
  timeArr = [{
    timeStart: _moment().subtract(1,'hour').startOf('hour').valueOf()
    timeEnd: _moment().startOf('hour').valueOf() - 1
    timeStep: 60 * 60 * 1000
    timeType: 'hour'
  }]
  timeArr = _common.getSplitTime timeStart, timeEnd, timeType if timeStart && timeEnd && timeType

  for time, index in timeArr
    ((time)->
      setTimeout(()->
          calculateByTime time, (err, result)->
      , index * 10 * 1000)
    )(time)






exports.getMRecords = (req, res, cb)->
  query = req.query

  _entity.m_records_calculated.findRecords query, (err, result)->

    cb err, result
