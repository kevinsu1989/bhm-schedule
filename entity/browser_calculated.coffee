#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:分浏览器的统计数据


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class BrowserCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/browser_calculated').schema


  saveRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


  findRecords: (data, cb)->
    sql = "select browser_name as name , pv as value, time_start from browser_calculated where 
      time_start >= #{data.time_start} and time_start < #{data.time_end} and
      page_name = '#{data.page_name}' "
    sql += " and type='#{data.type}' "
    sql += "  group by browser_name order by time_start"
    @execute sql, cb

  findSumRecords: (data, cb)->
    sql = "select browser_name as name , sum(pv) as value from browser_calculated where 
      time_start >= #{data.time_start} and time_start < #{data.time_end} and
      page_name = '#{data.page_name}' "
    sql += " and type='#{data.type}' "
    sql += "  group by browser_name order by time_start"
    @execute sql, cb
  
module.exports = new BrowserCalculated