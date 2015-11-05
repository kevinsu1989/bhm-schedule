_BaseEntity = require('bijou').BaseEntity
_async = require 'async'
_ = require 'lodash'


class MRecordsCalculated extends _BaseEntity
  constructor: ()->
    super require('../schema/m_records_calculated').schema


  addRecords: (list, cb)->
    @entity().insert(list).exec (err, data)->
      cb err, data

  getRecordsForDay: (data, cb)->
    sql = "select sum(pv) as pv ,sum(detail) as detail, sum(source) as source, sum(vv) as vv, sum(app) as app
           #{data.time_start} as time_start, #{data.time_end} as time_end, '#{data.time_type}' as time_type
           FROM m_records_calculated where time_start>#{data.time_start} and time_start<#{data.time_end}) and time_type='hour'" 
    @execute sql, cb

    

  findRecords: (data, cb)->
    sql="select * from m_records_calculated where time_start >= #{data.time_start} and time_start < #{data.time_end}"
    sql += " and time_type='#{data.type}' "
    sql += " order by time_start"

    console.log sql
    @execute sql, cb

module.exports = new MRecordsCalculated