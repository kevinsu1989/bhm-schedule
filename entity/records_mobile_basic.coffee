#    Author: 苏衎
#    E-mail: kevinsu1989@gmail.com
#    Date: 07/28/16 11:01 AM
#    Description:基础数据处理


_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class Records extends _BaseEntity
  constructor: ()->
    super require('../schema/records_mobile_basic_calculated').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

  # 查询基础数据    
  findRecords: (data, cb)->
    sql = "select avg(first_view) as first_view, avg(first_paint) as first_paint, avg(load_time) as load_time, avg(dom_ready) as dom_ready, 
     #{data.time_start} as time_start, #{data.time_end} as time_end, '#{data.time_type}' as time_type
    from records_mobile_basic a where 
    a.timestamp > #{data.time_start} and a.timestamp < #{data.time_end} and first_view>0 and first_paint>0 and load_time>0 and dom_ready>0"

    # sql += " and page_name='#{data.page_name}'" if !data.page_like

    # sql += " and a.url like '%.com#{data.page_like}%'" if data.page_like

    console.log sql
    
    @execute sql, cb



  # 查询pv数据    
  findPVRecords: (data, cb)->
    sql = "select count(*) as pv from records_mobile_basic  where 
    timestamp > #{data.time_start} and timestamp < #{data.time_end} "

    # sql += " and page_name='#{data.page_name}'" if !data.page_like

    # sql += " and url like '%.com#{data.page_like}%'" if data.page_like

    # sql += " and browser_name='#{data.browser_name}'" if data.browser_name

    console.log sql
    
    @execute sql, cb



module.exports = new Records