#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 10/09/15 17:01 AM
#    Description:

_async = require 'async'
_http = require('bijou').http
_ = require 'lodash'
_entity = require '../entity'
_common = require '../common'
_moment = require 'moment'




calculateBrowser = (time, page, cb)->
  params = {
    time_start: time.timeStart
    time_end: time.timeEnd
    page_like: page.page_like
    page_name: page.page_name
  }
  queue = []
  queue.push(
    (done)->
      _entity.records.browserPercent params, (err, result)->
        done err, result, time
  )

  queue.push(
    (result, time, done)->
      records = []
      for item in result
	      records.push {
	        time_start: time.timeStart
	        time_end: time.timeEnd
	        page_name: page.page_name
	        type: time.timeType
	        browser_name: item.name
	        pv: item.value
	      }
	      console.log item
      _entity.browser_calculated.saveRecords records, done
  )


  _async.waterfall queue, (err, result)->
    cb err, result


exports.calculateBrowserRecords = (timeStart, timeEnd, timeType)->
  # return null
  timeArr = [{
    timeStart: _moment().subtract(1,'hour').startOf('hour').valueOf()
    timeEnd: _moment().startOf('hour').valueOf() - 1
    timeStep: 60 * 60 * 1000
    timeType: 'hour'
  }]
  timeArr = _common.getSplitTime timeStart, timeEnd, timeType if timeStart && timeEnd && timeType

  _entity.page.findPages (err, pages)->

    for time, index in timeArr
      ((time)->
        setTimeout(()->
          for page in pages
            calculateBrowser time, page, (err, result)->
        , index * 1 * 15 * 1000)
      )(time)