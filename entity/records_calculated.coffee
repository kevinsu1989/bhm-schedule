#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 08/13/15 11:01 AM
#    Description:计算后的数据


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class RecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/records_calculated').schema


  saveCalculatedRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data


  findRecords: (data, cb)->
    #不区分浏览器PV
    # sql = "select * from records_calculated where 
    #   time_start >= #{data.time_start} and time_start < #{data.time_end} and
    #   page_name = '#{data.page_name}' "
    # sql += " and browser_name='#{data.browser_name}'" if data.browser_name
    # sql += " and browser_name is null" if !data.browser_name
    # sql += " and type='#{data.type}' "
    # sql += " order by time_start"

    #统计各浏览器PV
    sql="select m.*,time_start as ts,
    (select pv from browser_calculated where browser_name='ie' and time_start=ts and page_name='#{data.page_name}' and type='#{data.type}' limit 0,1) as iepv,
    (select pv from browser_calculated where browser_name='chrome' and time_start=ts and page_name='#{data.page_name}' and type='#{data.type}' limit 0,1) as chromepv
    from (select * from records_calculated a where 
    a.time_start >= #{data.time_start} and a.time_start < #{data.time_end} and a.page_name = '#{data.page_name}'"

    sql += " and browser_name='#{data.browser_name}'" if data.browser_name
    sql += " and browser_name is null" if !data.browser_name
    sql += " and type='#{data.type}' "
    sql += " order by a.time_start) m"

    console.log sql
    @execute sql, cb






  
module.exports = new RecordsCalculated